# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/pylint_parseable_parser'

module Warnings
  describe PylintParseableParser do
    before do
      @parser = PylintParseableParser.new
    end

    context '#parse' do
      context 'no categories' do
        before do
          @parser.parse(Assets::PYLINT_PARSEABLE_NO_CATEGORIES)
          @issue = @parser.issues.first
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(Assets::PYLINT_PARSEABLE_NO_CAT_ISSUE[:filename])
        end

        it 'maps category' do
          expect(@issue.category).to eq(Assets::PYLINT_PARSEABLE_NO_CAT_ISSUE[:category])
        end

        it 'maps line' do
          expect(@issue.line).to eq(Assets::PYLINT_PARSEABLE_NO_CAT_ISSUE[:line])
        end

        it 'maps message' do
          expect(@issue.message).to eq(Assets::PYLINT_PARSEABLE_NO_CAT_ISSUE[:message])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:high)
        end
      end

      context 'categories' do
        before do
          @parser.parse(Assets::PYLINT_PARSEABLE_CATEGORIES)
          @issue = @parser.issues.first
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(Assets::PYLINT_PARSEABLE_CAT_ISSUE[:filename])
        end

        it 'maps category' do
          expect(@issue.category).to eq(Assets::PYLINT_PARSEABLE_CAT_ISSUE[:category])
        end

        it 'maps line' do
          expect(@issue.line).to eq(Assets::PYLINT_PARSEABLE_CAT_ISSUE[:line])
        end

        it 'maps message' do
          expect(@issue.message).to eq(Assets::PYLINT_PARSEABLE_CAT_ISSUE[:message])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:low)
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
