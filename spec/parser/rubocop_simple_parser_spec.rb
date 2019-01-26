# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/rubocop_simple_parser'

module Warnings
  describe RubocopSimpleParser do
    before do
      @parser = RubocopSimpleParser.new
    end

    context '#parse' do
      context 'cops' do
        before do
          @parser.parse(Assets::RUBOCOP_SIMPLE_COPS)
          @issue = @parser.issues.first
          @first_issue = Assets::RUBOCOP_FIRST_ISSUE_SHORT
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(@first_issue[:path])
        end

        it 'maps category' do
          expect(@issue.category).to eq(@first_issue[:cop])
        end

        it 'maps line' do
          expect(@issue.line).to eq(@first_issue[:line])
        end

        it 'maps message' do
          expect(@issue.message).to eq(@first_issue[:message])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:low)
        end
      end

      context 'no cops' do
        before do
          @parser.parse(Assets::RUBOCOP_SIMPLE_NO_COPS)
          @issue = @parser.issues.first
          @first_issue = Assets::RUBOCOP_FIRST_ISSUE_SHORT
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(@first_issue[:path])
        end

        it 'does not map category' do
          expect(@issue.category).to be_nil
        end

        it 'maps line' do
          expect(@issue.line).to eq(@first_issue[:line])
        end

        it 'maps message' do
          expect(@issue.message).to eq(@first_issue[:message])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:low)
        end
      end
    end
  end
end
