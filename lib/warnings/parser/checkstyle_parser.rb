# frozen_string_literal: true

require_relative 'parser'
require_relative '../reporter/issue'
require_relative '../helper/severity_util'

module Warnings
  # Parser class for AndroidLint 'xml' formatted reports.
  class CheckstyleParser < Parser
    SEVERITY_ERROR = 'error'
    SEVERITY_WARNING = 'warning'

    def parse(file)
      xml = xml(file)
      return if xml.nil?

      files = xml.locate('checkstyle/file')
      files.each(&method(:store_file))
    end

    def working_directory
      "#{Dir.pwd}/"
    end

    private

    # Store the file element.
    #
    # @param file [Ox::Element] File issue Ox xml element.
    def store_file(file)
      errors = file.locate('error')
      errors.each do |error|
        issue = create_issue(error, file['name'])
        @issues << issue
      end
    end

    # Create an Issue item from xml element
    #
    # @param error [Ox::Element] Error Ox xml element.
    # @param file_name [String] Issue file path.
    # @return [Issue] New Issue item.
    def create_issue(error, file_name)
      issue = Issue.new
      issue.file_name = file_name.gsub(working_directory, '')
      issue.severity = to_severity(error.severity)
      issue.line = error.line.to_i
      issue.category = error.source.split('.').last.to_s
      issue.message = error.message
      issue
    end

    # Convert checkstyle xml severity to danger::warnings severity symbol.
    #
    # @return [Symbol] Warnings severity symbol.
    def to_severity(severity)
      case severity.downcase
        when SEVERITY_ERROR
          SeverityUtil::HIGH
        when SEVERITY_WARNING
          SeverityUtil::MEDIUM
        else
          SeverityUtil::LOW
      end
    end
  end
end
