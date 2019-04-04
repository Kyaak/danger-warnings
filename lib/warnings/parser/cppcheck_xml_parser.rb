# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'
require_relative '../const/severity'

module Warnings
  # Parser class for cppcheck 'xml' formatted reports.
  class CppcheckXmlParser < Parser
    def parse(file)
      xml = xml(file)
      return if xml.nil?

      errors = xml.locate('results/errors/error')
      errors.each(&method(:store_issue))
    end

    private

    # Store the error element.
    #
    # @param error [Ox::Element] Ox xml element.
    def store_issue(error)
      locations = error.locate('location')
      return if locations.empty?

      locations.each do |location|
        issue = Issue.new
        issue.file_name = location.file
        issue.severity = to_severity(error.severity)
        issue.line = location.line.to_i
        issue.category = error.id
        issue.message = message(error, location)
        @issues << issue
      end
    end

    def message(error, location)
      result = error.msg.dup
      result << " #{location.info}" if location.attributes.include?(:info)
      result
    end

    # Convert cppcheck xml severity to danger::warnings severity symbol.
    #
    # @param [String] severity Cppcheck severity level.
    # @return [Symbol] Warnings severity symbol.
    def to_severity(severity)
      case severity.downcase
        when Severity::ERROR
          Severity::HIGH
        when Severity::WARNING,
          Severity::PERFORMANCE,
          Severity::PORTABILITY
          Severity::MEDIUM
        when Severity::INFORMATION,
          Severity::STYLE
          Severity::LOW
        else
          Severity::LOW
      end
    end
  end
end
