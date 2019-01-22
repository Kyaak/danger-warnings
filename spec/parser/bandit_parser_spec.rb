require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/bandit_parser'

module Warnings
  describe BanditParser do
    before do
      @parser = BanditParser.new
    end

    context '#parse' do
      describe 'json' do
        context 'filled results' do
          before do
            @parser.parse(Assets::BANDIT_JSON)
            @issue = @parser.issues[0]
            expect(@issue).not_to be_nil
          end

          it 'parses issues' do
            expect(@parser.issues).not_to be_empty
            expect(@parser.issues.count).to eq(3)
          end

          it 'maps filename' do
            expect(@issue.file_name).to eq(Assets::BANDIT_FIRST_ISSUE[:filename])
          end

          it 'maps id' do
            expect(@issue.category).to eq(Assets::BANDIT_FIRST_ISSUE[:test_id])
          end

          it 'maps line' do
            expect(@issue.line).to eq(Assets::BANDIT_FIRST_ISSUE[:line_number])
          end

          it 'maps severity' do
            expect(@issue.severity).to eq(Assets::BANDIT_FIRST_ISSUE[:issue_severity])
          end

          it 'maps message' do
            expect(@issue.message).to eq(Assets::BANDIT_FIRST_ISSUE[:issue_text])
          end

          it 'maps name' do
            expect(@issue.name).to eq(Assets::BANDIT_FIRST_ISSUE[:test_name])
          end
        end

        context 'empty results' do
          it 'has no issues' do
            @parser.parse(Assets::BANDIT_EMPTY)
            expect(@parser.issues).to be_empty
          end
        end

        context 'missing results' do
          it 'raises error' do
            expect { @parser.parse(Assets::BANDIT_MISSING_RESULTS) }.to raise_error(BanditParser::ERROR_MISSING_KEY)
          end
        end

        context 'missing file' do
          it 'raises error' do
            file_name = 'invalid.json'
            expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_FILE_NOT_EXIST, file_name))
          end
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
end
