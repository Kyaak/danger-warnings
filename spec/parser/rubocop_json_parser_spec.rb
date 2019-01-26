# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/rubocop_json_parser'

module Warnings
  describe RubocopJsonParser do
    before do
      @parser = RubocopJsonParser.new
    end

    context '#parse' do
      before do
        @parser.parse(Assets::RUBOCOP_JSON)
        @issue = @parser.issues.first
        @first_issue_offense = Assets::RUBOCOP_FIRST_ISSUE_FULL[:offenses].first
      end

      it 'parses issues' do
        expect(@parser.issues).not_to be_empty
      end

      it 'maps path' do
        expect(@issue.file_name).to eq(Assets::RUBOCOP_FIRST_ISSUE_FULL[:path])
      end

      it 'maps category' do
        expect(@issue.category).to eq(@first_issue_offense[:cop_name])
      end

      it 'maps line' do
        expect(@issue.line).to eq(@first_issue_offense[:location][:line])
      end

      it 'maps message' do
        expect(@issue.message).to eq(@first_issue_offense[:message])
      end

      it 'maps severity' do
        expect(@issue.severity).to eq(:low)
      end
    end

    context 'multiple offenses' do
      it 'parses multiple offenses' do
        @parser.parse(Assets::RUBOCOP_MULTI_JSON)
        expect(@parser.issues.count).to eq(11)
      end
    end

    context 'not a json' do
      it 'raises error' do
        expect { @parser.parse(Assets::EMPTY_FILE) }.to raise_error(format('%<name>s is not a json file.', name: Assets::EMPTY_FILE))
      end
    end
  end
end
