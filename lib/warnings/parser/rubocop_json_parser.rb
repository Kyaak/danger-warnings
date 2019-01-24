require_relative 'parser'
require_relative '../helper/severity_util'
require_relative '../reporter/issue'

module Warnings
  # Parser class for rubocop 'json' formatted reports.
  class RubocopJsonParser < Parser
    def parse(file)
      json_hash = json(file)
      files = json_hash['files']
      files.each(&method(:store_issue))
    end

    private

    # Extract values to create an issue item.
    # It is stored in @issues.
    #
    # @param file_hash [Hash] Issue hash.
    def store_issue(file_hash)
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
