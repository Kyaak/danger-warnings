# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for cppcheck 'xml' formatted reports.
  class CppcheckXmlParser < Parser
    SEVERITY_ERROR = 'error'
    SEVERITY_WARNING = 'warning'
    SEVERITY_STYLE = 'style'
    SEVERITY_PERFORMANCE = 'performance'
    SEVERITY_PORTABILITY = 'portability'
    SEVERITY_INFORMATION = 'information'

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
    # @return [Symbol] Warnings severity symbol.
    def to_severity(severity)
      case severity.downcase
        when SEVERITY_ERROR
          SeverityUtil::HIGH
        when SEVERITY_WARNING,
          SEVERITY_PERFORMANCE,
          SEVERITY_PORTABILITY
          SeverityUtil::MEDIUM
        when SEVERITY_INFORMATION,
          SEVERITY_STYLE
          SeverityUtil::LOW
        else
          SeverityUtil::LOW
      end
    end
  end
end
