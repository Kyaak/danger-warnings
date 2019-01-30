# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/reporter_factory'

module Warnings
  describe ReporterFactory do
    context '#get' do
      it 'unknown symbol' do
        expect { ReporterFactory.create(:unknown, nil) }.to raise_error('Reporter \'unknown\' not supported.')
      end

      it 'unknown int' do
        expect { ReporterFactory.create(123, nil) }.to raise_error('Reporter \'123\' not supported.')
      end

      it 'unknown string' do
        expect { ReporterFactory.create('unknown', nil) }.to raise_error('Reporter \'unknown\' not supported.')
      end

      it 'bandit' do
        result = ReporterFactory.create(:bandit, nil)
        expect(result).not_to be_nil
        expect(result).to be_a(BanditReporter)
      end

      it 'pylint' do
        result = ReporterFactory.create(:pylint, nil)
        expect(result).not_to be_nil
        expect(result).to be_a(PylintReporter)
      end

      it 'rubocop' do
        result = ReporterFactory.create(:rubocop, nil)
        expect(result).not_to be_nil
        expect(result).to be_a(RubocopReporter)
      end

      it 'cppcheck' do
        result = ReporterFactory.create(:cppcheck, nil)
        expect(result).not_to be_nil
        expect(result).to be_a(CppcheckReporter)
      end

      it 'android_lint' do
        result = ReporterFactory.create(:android_lint, nil)
        expect(result).not_to be_nil
        expect(result).to be_a(AndroidLintReporter)
      end
    end
  end
end
