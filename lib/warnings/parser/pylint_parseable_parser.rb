# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for pylint 'parseable' formatted reports.
  class PylintParseableParser < Parser
    ISSUE_PATTERN = /(.*):(\d+):\s*\[(\w\d+)(\s*\((.*)\).*)?\]\s*(.*)/.freeze

    def parse(file)
      read_lines(file).each do |line|
        match = line.scan(ISSUE_PATTERN)
        store_issue(match[0]) unless match.empty?
      end
    end

    private

    # Extract values to create an issue item.
    # It is stored in @issues.
    #
    # @param match [Array] Issue match array.
    def store_issue(match)
      issue = Issue.new
      issue.file_name = match[0]
      issue.line = match[1]
      issue.category = category(match)
      issue.message = match[match.count - 1]
      issue.severity = SeverityUtil.rcwef_short(issue.category)
      @issues << issue
    end

    def category(match)
      category = match[2]
      category = "#{category} #{match[4]}" if match.count > 4 && !match[4].nil?
      category
    end
  end
end
