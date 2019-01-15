require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/bandit_parser'

module Warnings
  describe BanditParser do
    ASSETS_DIR = File.expand_path('../assets', __dir__)
    BANDIT_JSON = "#{ASSETS_DIR}/bandit.json".freeze
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_empty.json".freeze
    BANDIT_MISSING_RESULTS = "#{ASSETS_DIR}/bandit_missing_results.json".freeze

    FIRST_ISSUE = {
      code: "2852         except ImportError:\n2853             import pickle\n2854         with open(filename, 'wb') as outf:\n",
      filename: 'example/ply/yacc.py',
      issue_confidence: 'HIGH',
      issue_severity: 'LOW',
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
            @parser.parse(BANDIT_JSON)
            @issue = @parser.issues[0]
            expect(@issue).not_to be_nil
          end

          it 'parses issues' do
            expect(@parser.issues).not_to be_empty
            expect(@parser.issues.count).to eq(2)
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
            @parser.parse(BANDIT_EMPTY)
            expect(@parser.issues).to be_empty
          end
        end

        context 'missing results' do
          it 'raises error' do
            expect { @parser.parse(BANDIT_MISSING_RESULTS) }.to raise_error('Missing bandit key \'results\'.')
          end
        end

        context 'missing file' do
          it 'raises error' do
            expect { @parser.parse('invalid.json') }.to raise_error("File 'invalid.json' does not exist.")
          end
        end
      end

      describe 'unsupported type' do
        it 'raises error' do
          expect { @parser.parse('hello.txt') }.to raise_error('File type \'txt\' is not supported for parser Warnings::BanditParser.')
        end
      end
    end
  end
end
