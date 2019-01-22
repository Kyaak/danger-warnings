require_relative 'parser'
require_relative '../report/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for pylint formatted files.
  class RubocopParser < Parser
    NAME = 'RuboCop'.freeze
    ISSUE_PATTERN = /(.*):(\d+):\s*\[(\w\d+)\]\s*(.*)/.freeze

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
      read_lines(file).each do |line|
        match = line.scan(ISSUE_PATTERN)
        store_issue(match[0]) unless match.empty?
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
  end
end
