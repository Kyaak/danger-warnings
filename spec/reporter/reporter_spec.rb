# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/bandit_reporter'
require 'danger'

module Warnings
  describe Reporter do
    BANDIT_FILE_1 = 'example/ply/yacc_1.py'

    before do
      @dangerfile = testing_dangerfile
      @reporter = BanditReporter.new(@dangerfile)

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    context '#name' do
      it 'set' do
        test_name = 'My Test Name Report'
        @reporter.name = test_name
        expect(@reporter.name).to eq(test_name)
      end

      it 'not set' do
        expect(@reporter.name).to eq("#{BanditReporter::NAME} #{Reporter::DEFAULT_SUFFIX}")
      end
    end

    context '#reporter' do
      it 'raises if no file' do
        expect(@reporter.file).to be_nil
        expect { @reporter.report }.to raise_error(Reporter::ERROR_FILE_NOT_SET)
      end

      it 'does not reporter markdown if no issues' do
        @reporter.file = Assets::BANDIT_EMPTY
        @reporter.report
        @reporter.inline = false
        expect(@dangerfile.status_report[:markdowns]).to be_empty
        expect(@dangerfile.status_report[:warnings]).to be_empty
        expect(@dangerfile.status_report[:messages]).to be_empty
        expect(@dangerfile.status_report[:errors]).to be_empty
      end

      it 'does not reporter inline if no issues' do
        @reporter.file = Assets::BANDIT_EMPTY
        @reporter.inline = true
        @reporter.report
        expect(@dangerfile.status_report[:markdowns]).to be_empty
        expect(@dangerfile.status_report[:warnings]).to be_empty
        expect(@dangerfile.status_report[:messages]).to be_empty
        expect(@dangerfile.status_report[:errors]).to be_empty
      end

      context 'inline' do
        before do
          @reporter.format = :json
          @reporter.file = Assets::BANDIT_JSON
          @reporter.filter = false
        end

        it 'defaults inline false' do
          expect(@reporter.inline).not_to be_truthy
        end

        it 'inline false generates markdown' do
          @reporter.inline = false

          @reporter.report
          expect(@dangerfile.status_report[:markdowns]).not_to be_empty
          expect(@dangerfile.status_report[:warnings]).to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
        end

        it 'inline true generates warnings for files' do
          @reporter.inline = true

          @reporter.report
          expect(@dangerfile.status_report[:markdowns]).to be_empty
          expect(@dangerfile.status_report[:warnings]).not_to be_empty
          expect(@dangerfile.status_report[:messages]).to be_empty
          expect(@dangerfile.status_report[:errors]).to be_empty
          expect(@dangerfile.violation_report[:warnings].first.file).not_to be_empty
          expect(@dangerfile.violation_report[:warnings].first.line).not_to eq(0)
        end
      end

      context 'fail_error' do
        before do
          @reporter.format = :json
          @reporter.file = Assets::BANDIT_JSON
        end

        it 'default fail_error false' do
          expect(@reporter.fail_error).not_to be_truthy
        end

        context 'markdown' do
          before do
            @reporter.inline = false
            @reporter.filter = false
          end

          it 'fail_error false generates no error' do
            @reporter.fail_error = false

            @reporter.report
            expect(@dangerfile.status_report[:markdowns]).not_to be_empty
            expect(@dangerfile.status_report[:warnings]).to be_empty
            expect(@dangerfile.status_report[:messages]).to be_empty
            expect(@dangerfile.status_report[:errors]).to be_empty
          end

          it 'fail_error false generates error message' do
            @reporter.fail_error = true

            @reporter.report
            expect(@dangerfile.status_report[:markdowns]).not_to be_empty
            expect(@dangerfile.status_report[:warnings]).to be_empty
            expect(@dangerfile.status_report[:messages]).to be_empty
            expect(@dangerfile.status_report[:errors]).not_to be_empty
            error = @dangerfile.status_report[:errors].first
            expect(error).not_to eq(Reporter::ERROR_HIGH_SEVERITY)
          end
        end

        context 'inline' do
          before do
            @reporter.inline = true
            @reporter.filter = false
          end

          it 'fail_error false generates no error' do
            @reporter.fail_error = false

            @reporter.report
            expect(@dangerfile.status_report[:markdowns]).to be_empty
            expect(@dangerfile.status_report[:warnings]).not_to be_empty
            expect(@dangerfile.status_report[:messages]).to be_empty
            expect(@dangerfile.status_report[:errors]).to be_empty
          end

          it 'fail_error false generates error message' do
            @reporter.fail_error = true

            @reporter.report
            expect(@dangerfile.status_report[:markdowns]).to be_empty
            expect(@dangerfile.status_report[:warnings]).not_to be_empty
            expect(@dangerfile.status_report[:messages]).to be_empty
            expect(@dangerfile.status_report[:errors]).not_to be_empty
            error = @dangerfile.status_report[:errors].first
            expect(error).to include('High')
          end
        end
      end

      context 'filter' do
        before do
          @reporter.format = :json
          @reporter.file = Assets::BANDIT_JSON
          @dangerfile.git.stubs(:modified_files).returns(%W(#{BANDIT_FILE_1}))
        end

        it 'defaults filter true' do
          expect(@reporter.filter).to be_truthy
        end

        it 'filter false takes all issues' do
          @reporter.inline = true
          @reporter.filter = false

          @reporter.report
          expect(@dangerfile.violation_report[:warnings].size).to eq(3)
        end

        it 'filter true rejects unmodified files' do
          @reporter.inline = true
          @reporter.filter = true

          @reporter.report
          expect(@dangerfile.violation_report[:warnings].size).to eq(1)
          expect(@dangerfile.violation_report[:warnings].first.file).to eq(BANDIT_FILE_1)
        end

        it 'uses baseline if set' do
          directory = 'pre/dir'
          @reporter.inline = true
          @reporter.filter = true
          @reporter.baseline = directory
          @dangerfile.git.stubs(:modified_files).returns(%W(#{directory}/#{BANDIT_FILE_1}))

          @reporter.report
          expect(@dangerfile.violation_report[:warnings].size).to eq(1)
          expect(@dangerfile.violation_report[:warnings].first.file).to eq(BANDIT_FILE_1)
        end
      end
    end
  end
end
