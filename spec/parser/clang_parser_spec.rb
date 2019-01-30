# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/clang_parser'

module Warnings
  describe ClangParser do
    before do
      @parser = ClangParser.new
    end

    context '#parse' do
      context 'rubocop' do
        context 'cops' do
          before do
            @parser.parse(Assets::RUBOCOP_CLANG_COPS)
            @issue = @parser.issues.first
            @first_issue = Assets::RUBOCOP_FIRST_ISSUE_SHORT
          end

          it 'parses issues' do
            expect(@parser.issues).not_to be_empty
            expect(@parser.issues).not_to eq(1)
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
            @parser.parse(Assets::RUBOCOP_CLANG_NO_COPS)
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
end
