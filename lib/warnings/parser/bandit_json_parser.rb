# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'

module Warnings
  # Parser class for bandit 'json' formatted reports.
  class BanditJsonParser < Parser
    def parse(file)
      json_hash = json(file)
      results_hash = json_hash['results']
      results_hash.each(&method(:store_issue))
    end

    private

    # Extract values to create an issue item.
    # It is stored in @issues.
    #
    # @param hash [Hash] Issue hash.
    def store_issue(hash)
      issue = Issue.new
      issue.file_name = hash['filename']
      issue.severity = to_severity(hash['issue_severity'])
      issue.message = hash['issue_text']
      issue.line = hash['line_number']
      issue.category = "#{hash['test_id']}-#{hash['test_name']}"
      @issues << issue
    end

    # Convert bandit json severity to danger::warnings severity symbol.
    #
    # @return [Symbol] Warnings severity symbol.
    def to_severity(severity)
      severity.downcase.to_sym
    end
  end
end
