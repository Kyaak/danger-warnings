require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/rubocop_parser'

module Warnings
  describe RubocopParser do
    before do
      @parser = RubocopParser.new
    end

    context '#parse' do
      context 'json' do
        context 'default' do
          before do
            @parser.parse(Assets::RUBOCOP_JSON)
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

        context 'empty issues' do
          it 'has no issues' do
            @parser.parse(Assets::EMPTY_FILE)
            expect(@parser.issues).to be_empty
          end
        end
      end
    end
  end
end
