# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/pylint_json_parser'

module Warnings
  describe PylintJsonParser do
    before do
      @parser = PylintJsonParser.new
    end

    context '#parse' do
      before do
        @parser.parse(Assets::PYLINT_JSON)
        @issue = @parser.issues[0]
        expect(@issue).not_to be_nil
      end

      it 'parses issues' do
        expect(@parser.issues).not_to be_empty
        expect(@parser.issues.count).not_to eq(1)
      end

      it 'maps filename' do
        expect(@issue.file_name).to eq(Assets::PYLINT_JSON_ISSUE[:path])
      end

      it 'maps id type' do
        expect(@issue.category).to eq("#{Assets::PYLINT_JSON_ISSUE[:message_id]} #{Assets::PYLINT_JSON_ISSUE[:type]}")
      end

      it 'maps line' do
        expect(@issue.line).to eq(Assets::PYLINT_JSON_ISSUE[:line])
      end

      it 'maps severity' do
        expect(@issue.severity).to eq(:low)
      end

      it 'maps message' do
        expect(@issue.message).to eq(Assets::PYLINT_JSON_ISSUE[:message])
      end
    end

    describe 'unsupported type' do
      it 'raises error' do
        file_name = 'hello.txt'
        expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_EXT_NOT_JSON, file_name))
      end
    end
  end
end
