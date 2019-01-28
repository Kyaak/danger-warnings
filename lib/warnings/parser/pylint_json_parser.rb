# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'

module Warnings
  # Parser class for pylint 'json' formatted reports.
  class PylintJsonParser < Parser
    def parse(file)
      json_hash = json(file)
      json_hash.each(&method(:store_issue))
    end

    private

    # Extract values to create an issue item.
    # It is stored in @issues.
    #
    # @param hash [Hash] Issue hash.
    def store_issue(hash)
      issue = Issue.new
      issue.file_name = hash['path']
      issue.severity = SeverityUtil.rcwef_full(hash['type'])
      issue.message = hash['message']
      issue.line = hash['line']
      issue.category = "#{hash['message-id']} #{hash['type']}"
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
