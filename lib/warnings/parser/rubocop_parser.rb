require_relative 'parser'
require_relative '../report/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for rubocop reports.
  class RubocopParser < Parser
    NAME = 'RuboCop'.freeze
    FILE_PATTERN = /==\s(.*)\s==/.freeze
    ISSUE_PATTERN = /(\w):\s*(\d+):\s*\d+:\s(.*)/.freeze

    def parse(file)
      if json?(file)
        extract_json_issues(file)
      else
        extract_pattern_issues(file)
      end
    end

    def name
      NAME
    end

    private

    def extract_json_issues(file)
      json_hash = json(file)
      files = json_hash['files']
      files.each(&method(:store_json_issue))
    end

    def extract_pattern_issues(file)
      last_file = nil
      read_lines(file).each do |line|
        file_match = line.scan(FILE_PATTERN)
        unless file_match.empty?
          last_file = file_match[0][0]
          next
        end
        issue_match = line.scan(ISSUE_PATTERN)
        next if issue_match.empty?

        issue_content = issue_match[0]
        issue = {
          severity: issue_content[0],
          line: issue_content[1],
          message: issue_content[2]
        }
        store_simple_issue(last_file, issue)
      end
    end

    def store_json_issue(file_hash)
      offenses = file_hash['offenses']
      return if offenses.empty?

      offenses.each do |offense|
        issue = Issue.new
        issue.file_name = file_hash['path']
        issue.line = offense['location']['line']
        issue.category = offense['cop_name']
        issue.severity = SeverityUtil.rcwef_full(offense['severity'])
        issue.message = offense['message']
        @issues << issue
      end
    end

    def store_simple_issue(file, issue_hash)
      issue = Issue.new
      issue.file_name = file
      issue.line = issue_hash[:line].to_i
      issue.severity = SeverityUtil.rcwef_full(issue_hash[:severity])
      issue.message = issue_hash[:message]
      @issues << issue
    end
  end
end
