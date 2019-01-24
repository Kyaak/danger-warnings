require_relative '../reporter/issue'

module Warnings
  # Utility class to write the markdown and inline reports.
  module MessageUtil
    TABLE_HEADER = '|Severity|File|Message|'.freeze
    COLUMN_SEPARATOR = '|'.freeze
    TABLE_SEPARATOR = "#{COLUMN_SEPARATOR}---#{COLUMN_SEPARATOR}---#{COLUMN_SEPARATOR}---#{COLUMN_SEPARATOR}".freeze
    LINE_SEPARATOR = "\n".freeze

    module_function

    # Generate a markdown text message listing all issues as table.
    #
    # @param name [String] The name of the reporter to be printed.
    # @param issues [Array<Issue>] List of parsed issues.
    # @return [String] String in danger markdown format.
    def markdown(name, issues)
      result = header_name(name)
      result << header
      result << issues(issues)
    end

    # Create an inline comment containing all issue information.
    #
    # @param issue [Issue] The issue to reporter.
    # @return String Text to add as comment.
    def inline(issue)
      "#{issue.severity.to_s.capitalize}\n#{meta_information(issue)}\n#{issue.message}"
    end

    # Create the reporter name string.
    #
    # @param report_name [String] The name of the reporter.
    # @return [String] Text containing header name of the reporter.
    def header_name(report_name)
      "# #{report_name}#{LINE_SEPARATOR}"
    end

    # Create the base table header line.
    #
    # @return [String] String containing a markdown table header line.
    def header
      result = TABLE_HEADER.dup
      result << LINE_SEPARATOR
      result << TABLE_SEPARATOR
      result << LINE_SEPARATOR
    end

    # Create a string containing all issues prepared to be used in a markdown table.
    #
    # @param issues [Array<Issue>] List of parsed issues.
    # @return [String] String containing all issues.
    # rubocop:disable Metrics/AbcSize
    def issues(issues)
      result = ''
      issues.each do |issue|
        result << COLUMN_SEPARATOR.dup
        result << issue.severity.to_s.capitalize
        result << COLUMN_SEPARATOR
        result << "#{issue.file_name}:#{issue.line}"
        result << COLUMN_SEPARATOR
        result << "#{meta_information(issue)} #{issue.message}"
        result << COLUMN_SEPARATOR
        result << LINE_SEPARATOR
      end
      # rubocop:enable Metrics/AbcSize
      result
    end

    # Combine meta information about the issue.
    # Meta information are considered infos about the check itself.
    # e.g. category
    #
    # @param issue [Issue] Issue to extract information.
    # @return String combined information.
    def meta_information(issue)
      return unless issue.category

      result = '['
      result << issue.category
      result << ']'
    end
  end
end
