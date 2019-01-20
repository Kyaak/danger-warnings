require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/bandit_parser'

module Warnings
  describe BanditParser do
    FIRST_ISSUE = {
      code: "2852         except ImportError:\n2853             import pickle\n2854         with open(filename, 'wb') as outf:\n",
      filename: 'example/ply/yacc_1.py',
      issue_confidence: 'HIGH',
      issue_severity: :low,
      issue_text: 'Consider possible security implications associated with pickle module.',
      line_number: 2853,
      line_range: [
        2853
      ],
      more_info: 'https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b403-import-pickle',
      test_id: 'B403',
      test_name: 'blacklist'
    }.freeze

    before do
      @parser = BanditParser.new
    end

    context '#file_types' do
      it 'include json' do
        expect(@parser.file_types).to include(:json)
      end
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

          it 'maps name' do
            expect(@issue.file_name).to eq(FIRST_ISSUE[:filename])
          end

          it 'maps id' do
            expect(@issue.id).to eq(FIRST_ISSUE[:test_id])
          end

          it 'maps line' do
            expect(@issue.line).to eq(FIRST_ISSUE[:line_number])
          end

          it 'maps severity' do
            expect(@issue.severity).to eq(FIRST_ISSUE[:issue_severity])
          end

          it 'maps message' do
            expect(@issue.message).to eq(FIRST_ISSUE[:issue_text])
          end

          it 'maps name' do
            expect(@issue.name).to eq(FIRST_ISSUE[:test_name])
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
          ext = File.extname(file_name).delete('.')
          expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_EXT_NOT_SUPPORTED,
                                                                    ext,
                                                                    @parser.class.name))
        end
      end
    end
  end
end
