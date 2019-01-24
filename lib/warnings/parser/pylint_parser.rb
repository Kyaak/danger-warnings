require_relative 'parser'
require_relative '../report/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for pylint formatted files.
  class PylintParser < Parser
    NAME = 'Pylint'.freeze
    ISSUE_PATTERN = /(.*):(\d+):\s*\[(\w\d+)\]\s*(.*)/.freeze

    def parse(file)
      read_lines(file).each do |line|
        match = line.scan(ISSUE_PATTERN)
        store_issue(match[0]) unless match.empty?
      end
    end

    def name
      NAME
    end

    private

    # Match the regex result and store it as issue implementation.
    #
    # @param match [Array<String>] The regex matches for a single issue.
    # @return Void
    def store_issue(match)
      issue = Issue.new
      issue.file_name = match[0]
      issue.line = match[1]
      issue.category = match[2]
      issue.severity = SeverityUtil.rcwef_short(issue.category)
      issue.message = match[3]
      @issues << issue
    end
  end
end
