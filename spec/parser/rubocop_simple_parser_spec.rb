# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/rubocop_simple_parser'

module Warnings
  describe RubocopSimpleParser do
    before do
      @parser = RubocopSimpleParser.new
    end

    context '#parse' do
      before do
        @parser.parse(Assets::RUBOCOP_SIMPLE)
        @issue = @parser.issues.first
        @first_issue_offense = Assets::RUBOCOP_FIRST_ISSUE[:offenses].first
      end

      it 'parses issues' do
        expect(@parser.issues).not_to be_empty
      end

      it 'maps path' do
        expect(@issue.file_name).to eq(Assets::RUBOCOP_FIRST_ISSUE[:path])
      end

      it 'maps category' do
        expect(@issue.category).to be_nil
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
  end
end
