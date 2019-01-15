require_relative 'issue'

module Warnings
  # Utility class to write the markdown report.
  module MarkdownUtil
    TABLE_HEADER = 'Severity|File|Message'.freeze
    TABLE_SEPARATOR = '---'.freeze
    COLUMN_SEPARATOR = '|'.freeze
    LINE_SEPARATOR = "\n".freeze

    module_function

    # Generate a markdown text message listing all issues as table.
    #
    # @param name [String] The name of the report to be printed.
    # @param issues [Array<Issue>] List of parsed issues.
    # @return [String] String in danger markdown format.
    def generate(name, issues)
      result = header_name(name)
      result << header
      result << issues(issues)
    end

    # Create the report name string.
    #
    # @param report_name [String] The name of the report.
    # @return [String] Text containing header name of the report.
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
        result << issue.severity.to_s.upcase
        result << COLUMN_SEPARATOR
        result << "#{issue.file_name}:#{issue.line}"
        result << COLUMN_SEPARATOR
        result << "[#{issue.id}-#{issue.name}] #{issue.message}"
        result << LINE_SEPARATOR
      end
      # rubocop:enable Metrics/AbcSize
      result
    end
  end
end
