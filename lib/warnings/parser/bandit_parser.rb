require_relative 'parser'
require_relative '../issue'

module Warnings
  # Parser class for bandit generated json files.
  class BanditParser < Parser
    RESULTS_KEY = 'results'.freeze
    FILE_TYPES = %i(json).freeze
    NAME = 'Bandit'.freeze

    def file_types
      FILE_TYPES
    end

    def parse(file)
      json_hash = json(file)
      results_hash = json_hash[RESULTS_KEY]
      raise("Missing bandit key 'results'.") if results_hash.nil?

      results_hash.each(&method(:store_issue))
    end

    def name
      NAME
    end

    private

    def store_issue(hash)
      issue = Issue.new
      issue.file_name = hash['filename']
      issue.severity = hash['issue_severity']
      issue.message = hash['issue_text']
      issue.line = hash['line_number']
      issue.id = hash['test_id']
      issue.name = hash['test_name']
      @issues << issue
    end
  end
end
