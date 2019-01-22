require_relative '../spec_helper'
require_relative '../../lib/warnings/helper/message_util'

module Warnings
  describe Warnings::MessageUtil do
    MARKDOWN_TEST_REPORT_NAME = 'My Report Name'.freeze
    COLUMN_ONE = 1
    COLUMN_TWO = 2
    COLUMN_THREE = 3

    context '#markdown' do
      context 'header' do
        it 'adds header name at first line' do
          result = MessageUtil.markdown(MARKDOWN_TEST_REPORT_NAME, [])
          header_name = result.split(MessageUtil::LINE_SEPARATOR).first
          expect(header_name).to eq("# #{MARKDOWN_TEST_REPORT_NAME}")
        end

        it 'adds table header at second line' do
          result = MessageUtil.markdown(MARKDOWN_TEST_REPORT_NAME, [])
          table_header = result.split(MessageUtil::LINE_SEPARATOR)[1]
          expect(table_header).to eq(MessageUtil::TABLE_HEADER)
        end

        it 'adds table separator at third line' do
          result = MessageUtil.markdown(MARKDOWN_TEST_REPORT_NAME, [])
          table_header = result.split(MessageUtil::LINE_SEPARATOR)[2]
          expect(table_header).to eq(MessageUtil::TABLE_SEPARATOR)
        end
      end

      context 'with issues' do
        before do
          @issue = Issue.new
          @issue.severity = :low
          @issue.name = 'blacklist'
          @issue.file_name = 'hello/test.py'
          @issue.message = 'Consider possible security implications associated with pickle module.'
          @issue.line = 1234
          @issue.category = 'B403'

          result = MessageUtil.markdown(MARKDOWN_TEST_REPORT_NAME, [@issue])
          issue_line = result.split(MessageUtil::LINE_SEPARATOR)[3]
          @issue_columns = issue_line.split(MessageUtil::COLUMN_SEPARATOR)
        end

        it 'first column contains severity upcase' do
          text = @issue_columns[COLUMN_ONE]
          expect(text).not_to be_nil
          expect(text).to eq(@issue.severity.to_s.capitalize)
        end

        it 'second column contains filename:line' do
          text = @issue_columns[COLUMN_TWO]
          expect(text).not_to be_nil
          expect(text).to eq("#{@issue.file_name}:#{@issue.line}")
        end

        it 'third column contains [category-name]' do
          text = @issue_columns[COLUMN_THREE]
          expect(text).not_to be_nil
          match = text.match(/^\[#{@issue.category}-#{@issue.name}\]/)
          expect(match).not_to be_nil
        end

        it 'does not append name' do
          @issue.name = nil
          result = MessageUtil.markdown(MARKDOWN_TEST_REPORT_NAME, [@issue])
          issue_line = result.split(MessageUtil::LINE_SEPARATOR)[3]
          @issue_columns = issue_line.split(MessageUtil::COLUMN_SEPARATOR)

          text = @issue_columns[COLUMN_THREE]
          expect(text).not_to be_nil
          match = text.match(/^\[#{@issue.category}\]/)
          expect(match).not_to be_nil
        end

        it 'third column contains message' do
          text = @issue_columns[COLUMN_THREE]
          expect(text).not_to be_nil
          match = text.match(/#{@issue.message}/)
          expect(match).not_to be_nil
        end
      end
    end

    context '#inline' do
      before do
        @issue = Issue.new
        @issue.severity = :low
        @issue.name = 'blacklist'
        @issue.file_name = 'hello/test.py'
        @issue.message = 'Consider possible security implications associated with pickle module.'
        @issue.line = 1234
        @issue.category = 'B403'

        result = MessageUtil.inline(@issue)
        @issue_lines = result.split(MessageUtil::LINE_SEPARATOR)
      end

      it 'first line contains severity upcase' do
        text = @issue_lines[0]
        expect(text).not_to be_nil
        expect(text).to eq(@issue.severity.to_s.capitalize)
      end

      it 'second line contains [category-name]' do
        text = @issue_lines[1]
        expect(text).not_to be_nil
        match = text.match(/^\[#{@issue.category}-#{@issue.name}\]/)
        expect(match).not_to be_nil
      end

      it 'does not append name' do
        @issue.name = nil
        result = MessageUtil.inline(@issue)
        @issue_lines = result.split(MessageUtil::LINE_SEPARATOR)

        text = @issue_lines[1]
        expect(text).not_to be_nil
        match = text.match(/^\[#{@issue.category}\]/)
        expect(match).not_to be_nil
      end

      it 'third line contains message' do
        text = @issue_lines[2]
        expect(text).not_to be_nil
        match = text.match(/#{@issue.message}/)
        expect(match).not_to be_nil
      end
    end
  end
end
