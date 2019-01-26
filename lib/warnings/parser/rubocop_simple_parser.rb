# frozen_string_literal: true

require_relative 'parser'
require_relative '../helper/severity_util'
require_relative '../reporter/issue'

module Warnings
  # Parser class for rubocop 'simple' formatted reports.
  class RubocopSimpleParser < Parser
    FILE_PATTERN = /==\s(.*)\s==/.freeze
    ISSUE_PATTERN = /(\w):\s*(\d+):\s*\d+:\s(.*)/.freeze

    def parse(file)
      last_file = nil
      read_lines(file).each do |line|
        file_match = line.scan(FILE_PATTERN)
        unless file_match.empty?
          last_file = file_match[0][0]
          next
        end

        issue_match = line.scan(ISSUE_PATTERN)
        next if issue_match.empty?

        issue = extract_issue(issue_match)
        store_issue(last_file, issue)
      end
    end

    private

    # Read issue content from a line match.
    #
    # @param match [Array<String>] Array of issue content matches.
    # @return [Hash] Mapped issue values.
    def extract_issue(match)
      content = match[0]
      {
        severity: content[0],
        line: content[1],
        message: content[2]
      }
    end

    # Extract values to create an issue item.
    # It is stored in @issues.
    #
    # @param file [String] Issue file.
    # @param issue_hash [Hash] Issue hash content.
    def store_issue(file, issue_hash)
      issue = Issue.new
      issue.file_name = file
      issue.line = issue_hash[:line].to_i
      issue.severity = issue_hash[:severity]
      issue.severity = SeverityUtil.rcwef_full(issue.severity)
      issue.message = issue_hash[:message]
      @issues << issue
    end
  end
end
