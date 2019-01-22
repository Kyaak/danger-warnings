require_relative 'parser'
require_relative '../report/issue'

module Warnings
  # Parser class for pylint formatted files.
  class PylintParser < Parser
    NAME = 'PyLint'.freeze
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
      issue.severity = map_severity(issue.category)
      issue.message = match[3]
      @issues << issue
    end

    # Map the id / category of the parsed issue to a defined severity level.
    #
    # @param id [String] Pylint id.
    # @return [Symbol] Mapped severity level.
    def map_severity(id)
      char = id.chars.first
      case char
      when 'R', 'C'
        :low
      when 'W'
        :normal
      when 'E', 'F'
        :high
      else
        :low
      end
    end
  end
end
