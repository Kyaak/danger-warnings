require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/pylint_parser'

module Warnings
  describe PylintParser do
    PYLINT_FIRST_ISSUE = {
      filename: 'test_project/__init__.py',
      line: '1',
      category: 'F403',
      message: "'from test_project import *' used; unable to detect undefined names"
    }.freeze

    before do
      @parser = PylintParser.new
    end

    context '#parse' do
      context 'filled results' do
        before do
          @parser.parse(Assets::PYLINT_TXT)
          @issue = @parser.issues.first
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(PYLINT_FIRST_ISSUE[:filename])
        end

        it 'maps id' do
          expect(@issue.category).to eq(PYLINT_FIRST_ISSUE[:category])
        end

        it 'maps line' do
          expect(@issue.line).to eq(PYLINT_FIRST_ISSUE[:line])
        end

        it 'maps message' do
          expect(@issue.message).to eq(PYLINT_FIRST_ISSUE[:message])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:high)
        end
      end

      context 'empty file' do
        it 'has no issues' do
          @parser.parse(Assets::EMPTY_FILE)
          expect(@parser.issues).to be_empty
        end
      end

      context 'missing file' do
        it 'raises error' do
          file_name = 'invalid'
          expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_FILE_NOT_EXIST, file_name))
        end
      end
    end
  end
end
