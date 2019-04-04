# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for AndroidLint 'xml' formatted reports.
  class AndroidLintParser < Parser
    def parse(file)
      xml = xml(file)
      return if xml.nil?

      errors = xml.locate('issues/issue')
      errors.each(&method(:store_issue))
    end

    private

    # Store the issue element.
    #
    # @param error [Ox::Element] Issue Ox xml element.
    def store_issue(error)
      locations = error.locate('location')
      # take first location as multiple are same res files
      location = locations.first
      issue = create_issue(error, location)
      @issues << issue
    end

    # Create an Issue item from xml element
    #
    # @param error [Ox::Element] Issue Ox xml element.
    # @param location [Ox::Element] Location Ox xml element.
    # @return [Issue] New Issue item.
    def create_issue(error, location)
      issue = Issue.new
      issue.file_name = location.file.gsub(work_dir, '')
      issue.severity = SeverityUtil.rcwef_full(error.severity)
      issue.line = location.line.to_i if location.attributes.include?(:line)
      issue.category = "#{error.category} #{error.id}"
      issue.message = error.message
      issue
    end
  end
end
