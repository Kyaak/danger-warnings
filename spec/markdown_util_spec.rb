require_relative 'spec_helper'
require_relative '../lib/warnings/markdown_util'

module Warnings
  describe Warnings::MarkdownUtil do
    MARKDOWN_TEST_REPORT_NAME = 'My Report Name'.freeze

    context '#generate' do
      context 'header' do
        it 'adds header name at first line' do
          result = MarkdownUtil.generate(MARKDOWN_TEST_REPORT_NAME, [])
          header_name = result.split(MarkdownUtil::LINE_SEPARATOR).first
          expect(header_name).to eq("# #{MARKDOWN_TEST_REPORT_NAME}")
        end

        it 'adds table header at second line' do
          result = MarkdownUtil.generate(MARKDOWN_TEST_REPORT_NAME, [])
          table_header = result.split(MarkdownUtil::LINE_SEPARATOR)[1]
          expect(table_header).to eq(MarkdownUtil::TABLE_HEADER)
        end

        it 'adds table separator at third line' do
          result = MarkdownUtil.generate(MARKDOWN_TEST_REPORT_NAME, [])
          table_header = result.split(MarkdownUtil::LINE_SEPARATOR)[2]
          expect(table_header).to eq(MarkdownUtil::TABLE_SEPARATOR)
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
          @issue.id = 'B403'

          result = MarkdownUtil.generate(MARKDOWN_TEST_REPORT_NAME, [@issue])
          @issue_line = result.split(MarkdownUtil::LINE_SEPARATOR)[3]
          @issue_columns = @issue_line.split(MarkdownUtil::COLUMN_SEPARATOR)
        end

        it 'first column contains severity upcase' do
          text = @issue_columns[0]
          expect(text).not_to be_nil
          expect(text).to eq(@issue.severity.to_s.upcase)
        end

        it 'second column contains filename:line' do
          text = @issue_columns[1]
          expect(text).not_to be_nil
          expect(text).to eq("#{@issue.file_name}:#{@issue.line}")
        end

        it 'third column contains [id-name]' do
          text = @issue_columns[2]
          expect(text).not_to be_nil
          match = text.match(/^\[#{@issue.id}-#{@issue.name}\]/)
          expect(match).not_to be_nil
        end
      end
    end
  end
end
