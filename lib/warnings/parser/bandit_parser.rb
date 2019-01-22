require_relative 'parser'
require_relative '../report/issue'

module Warnings
  # Parser class for bandit generated json files.
  class BanditParser < Parser
    RESULTS_KEY = 'results'.freeze
    FILE_TYPES = %i(json).freeze
    NAME = 'Bandit'.freeze
    ERROR_MISSING_KEY = "Missing bandit key '#{RESULTS_KEY}'.".freeze

    def file_types
      FILE_TYPES
    end

    def parse(file)
      json_hash = json(file)
      results_hash = json_hash[RESULTS_KEY]
      raise(ERROR_MISSING_KEY) if results_hash.nil?

      results_hash.each(&method(:store_issue))
    end

    def name
      NAME
    end

    private

    def store_issue(hash)
      issue = Issue.new
      issue.file_name = hash['filename']
      issue.severity = to_severity(hash['issue_severity'])
      issue.message = hash['issue_text']
      issue.line = hash['line_number']
      issue.category = hash['test_id']
      issue.name = hash['test_name']
      @issues << issue
    end

    def to_severity(severity)
      severity.downcase.to_sym
    end
  end
end
