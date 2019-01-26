# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for clang formatted reports.
  class ClangParser < Parser
    ISSUE_PATTERN = /(.*):(\d+):(\d+):\s(\w):\s(.*)/.freeze

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
      issue.category = match[3]
      issue.severity = SeverityUtil.rcwef_short(issue.category)
      issue.message = match[4]
      @issues << issue
    end
  end
end
