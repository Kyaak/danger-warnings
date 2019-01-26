# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for clang formatted reports.
  class ClangParser < Parser
    ISSUE_PATTERN = %r{(.+):(\d+):\d+:\s*(\w):\s*(\w+/\w+)?(:\s*)?(.+)}.freeze

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
      issue.line = match[1].to_i
      issue.severity = SeverityUtil.rcwef_short(match[2])
      issue.category = match[3] if match.count > 3
      issue.message = match[match.count - 1]
      @issues << issue
    end
  end
end
