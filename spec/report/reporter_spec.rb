require_relative '../spec_helper'
require_relative '../../lib/warnings/report/reporter'
require 'danger'

module Warnings
  describe Reporter do
    BANDIT_FILE_1 = 'example/ply/yacc_1.py'.freeze

    before do
      @dangerfile = testing_dangerfile
      @reporter = Reporter.new(@dangerfile)

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    context '#name' do
      it 'returns default' do
        expect(@reporter.name).to eq(Reporter::DEFAULT_NAME)
      end

      context 'set' do
        REPORTER_TEST_NAME = 'My Test Name Report'.freeze

        before do
          @reporter.name = REPORTER_TEST_NAME
        end

        it 'without parser' do
          expect(@reporter.parser).to be_nil
          expect(@reporter.name).to eq(REPORTER_TEST_NAME)
        end

        it 'with parser' do
          @reporter.parser = :bandit
          expect(@reporter.parser).not_to be_nil
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.name).to eq(REPORTER_TEST_NAME)
        end
      end

      context 'not set' do
        it 'without parser' do
          expect(@reporter.parser).to be_nil
          expect(@reporter.parser_impl).to be_nil
          expect(@reporter.name).to eq(Reporter::DEFAULT_NAME)
        end

        it 'with parser' do
          @reporter.parser = :bandit
          expect(@reporter.parser).not_to be_nil
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.name).to eq("#{BanditParser::NAME} #{Reporter::DEFAULT_NAME}")
        end
      end
    end

    context '#parser' do
      context 'valid name' do
        it 'sets #parser and #parser_impl' do
          @reporter.parser = :bandit
          expect(@reporter.parser).to eq(:bandit)
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.parser_impl).to be_a(BanditParser)
        end
      end

      context 'invalid name' do
        it 'setter raises error' do
          expect { @reporter.parser = :unknown }.to raise_error(format(ParserFactory::ERROR_NOT_SUPPORTED,
                                                                       'unknown'))
        end
      end
    end

    context '#report' do
      it 'raises if no parser' do
        expect(@reporter.parser).to be_nil
        expect { @reporter.report }.to raise_error(Reporter::ERROR_PARSER_NOT_SET)
      end

      it 'raises if no file' do
        @reporter.parser = :bandit
        expect(@reporter.file).to be_nil
        expect { @reporter.report }.to raise_error(Reporter::ERROR_FILE_NOT_SET)
      end

      it 'does not report markdown if no issues' do
        @reporter.parser = :bandit
        @reporter.file = Assets::BANDIT_EMPTY
        @reporter.report
        @reporter.inline = false
        expect(@dangerfile.status_report[:markdowns]).to be_empty
        expect(@dangerfile.status_report[:warnings]).to be_empty
        expect(@dangerfile.status_report[:messages]).to be_empty
        expect(@dangerfile.status_report[:errors]).to be_empty
      end

      it 'does not report inline if no issues' do
        @reporter.parser = :bandit
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
          @reporter.parser = :bandit
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
          @reporter.parser = :bandit
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
          @reporter.parser = :bandit
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

    context 'bandit' do
      it 'runs markdown' do
        @reporter.inline = false
        @reporter.filter = false
        @reporter.parser = :bandit
        @reporter.file = Assets::BANDIT_JSON
        @reporter.report
        expect(@dangerfile.status_report[:markdowns]).not_to be_empty
      end

      it 'runs inline' do
        @reporter.inline = true
        @reporter.filter = false
        @reporter.parser = :bandit
        @reporter.file = Assets::BANDIT_JSON
        @reporter.report
        expect(@dangerfile.status_report[:warnings]).not_to be_empty
      end
    end

    context 'pylint' do
      it 'runs markdown' do
        @reporter.inline = false
        @reporter.filter = false
        @reporter.parser = :pylint
        @reporter.file = Assets::PYLINT_TXT
        @reporter.report
        expect(@dangerfile.status_report[:markdowns]).not_to be_empty
      end

      it 'runs inline' do
        @reporter.inline = true
        @reporter.filter = false
        @reporter.parser = :pylint
        @reporter.file = Assets::PYLINT_TXT
        @reporter.report
        expect(@dangerfile.status_report[:warnings]).not_to be_empty
      end
    end
  end
end
