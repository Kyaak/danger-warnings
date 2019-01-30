# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/android_lint_parser'

module Warnings
  describe AndroidLintParser do
    before do
      @parser = AndroidLintParser.new
    end

    describe '#working_directory' do
      it 'returns current directory with slash' do
        expect(@parser.working_directory).to eq("#{Dir.pwd}/")
      end
    end

    describe '#parse' do
      context 'filled results' do
        before do
          @parser.stubs(:working_directory).returns('/Users/Martin/Downloads/MyApplication/')
          @parser.parse(Assets::ANDROID_LINT)
          @issue = @parser.issues[0]
          expect(@issue).not_to be_nil
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
          expect(@parser.issues).not_to eq(1)
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(Assets::ANDROID_LINT_FIRST_ISSUE[:location][:file])
        end

        it 'maps category' do
          category = Assets::ANDROID_LINT_FIRST_ISSUE[:category]
          id = Assets::ANDROID_LINT_FIRST_ISSUE[:id]
          expect(@issue.category).to eq("#{category} #{id}")
        end

        it 'maps line' do
          expect(@issue.line).to eq(Assets::ANDROID_LINT_FIRST_ISSUE[:location][:line])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:medium)
        end

        it 'maps message' do
          expect(@issue.message).to eq(Assets::ANDROID_LINT_FIRST_ISSUE[:message])
        end
      end

      context 'empty issues' do
        it 'has no issues' do
          @parser.parse(Assets::ANDROID_LINT_EMPTY_ISSUES)
          expect(@parser.issues).to be_empty
        end
      end

      context 'empty file' do
        it 'has no issues' do
          @parser.parse(Assets::EMPTY_XML)
          expect(@parser.issues).to be_empty
        end
      end

      context 'missing file' do
        it 'raises error' do
          file_name = 'invalid.xml'
          expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_FILE_NOT_EXIST, file_name))
        end
      end

      context 'multiple locations' do
        it 'create issue for first location' do
          @parser.parse(Assets::ANDROID_LINT_MULTI_LOCATION)
          expect(@parser.issues.count).to eq(1)
        end
      end
    end

    describe 'unsupported type' do
      it 'raises error' do
        file_name = 'hello.txt'
        expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_EXT_NOT_XML, file_name))
      end
    end
  end
end
