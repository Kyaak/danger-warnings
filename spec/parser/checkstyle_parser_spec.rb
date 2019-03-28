# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/checkstyle_parser'

module Warnings
  describe CheckstyleParser do
    before do
      @parser = CheckstyleParser.new
    end

    describe '#working_directory' do
      it 'returns current directory with slash' do
        expect(@parser.working_directory).to eq("#{Dir.pwd}/")
      end
    end

    describe '#parse' do
      context 'filled results' do
        before do
          @parser.stubs(:working_directory).returns('/Users/Martin/Desktop/JavaAndroidApplication/')
          @parser.parse(Assets::CHECKSTYLE_XML)
          @issue = @parser.issues[0]
          expect(@issue).not_to be_nil
        end

        it 'parses issues' do
          expect(@parser.issues).not_to be_empty
          expect(@parser.issues).not_to eq(1)
        end

        it 'maps filename' do
          expect(@issue.file_name).to eq(Assets::CHECKSTYLE_XML_FIRST_ISSUE[:name])
        end

        it 'maps category' do
          source = Assets::CHECKSTYLE_XML_FIRST_ISSUE[:source]
          category = source.split('.').last
          expect(@issue.category).to eq(category.to_s)
        end

        it 'maps line' do
          expect(@issue.line).to eq(Assets::CHECKSTYLE_XML_FIRST_ISSUE[:line])
        end

        it 'maps severity' do
          expect(@issue.severity).to eq(:medium)
        end

        it 'maps message' do
          expect(@issue.message).to eq(Assets::CHECKSTYLE_XML_FIRST_ISSUE[:message])
        end
      end

      context 'empty issues' do
        it 'has no issues' do
          @parser.parse(Assets::CHECKSTYLE_EMPTY_XML)
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

      context 'multiple errors' do
        it 'create issues for each file' do
          @parser.parse(Assets::CHECKSTYLE_XML)
          multiple_issues = false
          @parser.issues.each do |first_issue|
            @parser.issues.each do |second_issue|
              if first_issue.file_name.eql?(second_issue.file_name)
                multiple_issues = true
                break
              end
            end
          end
          expect(multiple_issues).to be_truthy
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
