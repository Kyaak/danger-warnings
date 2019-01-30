# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/cppcheck_xml_parser'

module Warnings
  describe CppcheckXmlParser do
    before do
      @parser = CppcheckXmlParser.new
    end

    context '#parse' do
      context 'filled results' do
        before do
          @parser.parse(Assets::CPPCHECK_XML)
          @issue = @parser.issues[0]
          expect(@issue).not_to be_nil
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(Assets::CPPCHECK_FIRST_ISSUE[:location])
        end

        it 'maps category' do
          expect(@issue.category).to eq(Assets::CPPCHECK_FIRST_ISSUE[:category])
        end

        it 'maps line' do
          expect(@issue.line).to eq(Assets::CPPCHECK_FIRST_ISSUE[:line])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(Assets::CPPCHECK_FIRST_ISSUE[:severity])
        end

        it 'maps message' do
          expect(@issue.message).to eq(Assets::CPPCHECK_FIRST_ISSUE[:message])
        end
      end

      context 'empty results' do
        it 'has no issues' do
          @parser.parse(Assets::CPPCHECK_EMPTY_RESULTS_XML)
          expect(@parser.issues).to be_empty
        end
      end

      context 'empty errors' do
        it 'has no issues' do
          @parser.parse(Assets::CPPCHECK_EMPTY_ERRORS_XML)
          expect(@parser.issues).to be_empty
        end
      end

      context 'empty file' do
        it 'has no issues' do
          @parser.parse(Assets::EMPTY_XML)
          expect(@parser.issues).to be_empty
        end
      end

      context 'missing file' do
        it 'raises error' do
          file_name = 'invalid.xml'
          expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_FILE_NOT_EXIST, file_name))
        end
      end

      context 'multiple locations' do
        it 'create issue for each location' do
          @parser.parse(Assets::CPPCHECK_MULTI_LOCATION_XML)
          expect(@parser.issues.count).to eq(2)
          check = Assets::CPPCHECK_MULTI_LOCATION_ISSUE
          first_location = check[:locations][0]
          second_location = check[:locations][1]
          check_eq_issue(first_location, check[:message], check[:category], :medium, @parser.issues[0])
          check_eq_issue(second_location, check[:message], check[:category], :medium, @parser.issues[1])
        end

        # rubocop:disable Metrics/AbcSize
        def check_eq_issue(location, message, category, severity, issue)
          expect(issue.file_name).to eq(location[:location])
          expect(issue.line).to eq(location[:line])
          expect(issue.message).to eq("#{message} #{location[:info]}")
          expect(issue.category).to eq(category)
          expect(issue.severity).to eq(severity)
          # rubocop:enable Metrics/AbcSize
        end
      end
    end

    describe 'unsupported type' do
      it 'raises error' do
        file_name = 'hello.txt'
        expect { @parser.parse(file_name) }.to raise_error(format(Parser::ERROR_EXT_NOT_XML, file_name))
      end
    end
  end
end
