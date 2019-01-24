# frozen_string_literal: true

require_relative '../helper/message_util'

module Warnings
  # Base reporter class to define attributes and common method to create a reporter.
  class Reporter
    DEFAULT_INLINE = false
    DEFAULT_FILTER = true
    DEFAULT_FAIL = false
    DEFAULT_SUFFIX = 'Report'
    ERROR_PARSER_NOT_SET = 'Parser is not set.'
    ERROR_FILE_NOT_SET = 'File is not set.'
    ERROR_HIGH_SEVERITY = '%s has high severity errors.'
    ERROR_NOT_SUPPORTED = 'Parser \'%s\' not supported.'

    # The name of this reporter. It is used to identify your reporter in the comments.
    attr_writer :name
    # Whether to comment a markdown reporter or do an inline comment on the file.
    #
    # @return [Bool] Use inline comments.
    attr_accessor :inline
    # Whether to filter and reporter only for changes files.
    # If this is set to false, all issues are of a reporter are included in the comment.
    #
    # @return [Bool] Filter for changes files.
    attr_accessor :filter
    # Whether to fail the PR if any high issue is reported.
    #
    # @return [Bool] Fail on high issues.
    attr_accessor :fail_error
    # The parser to be used to read issues out of the file.
    #
    # @return [Symbol] Name of the parser.
    attr_writer :format
    # The file path to parse.
    #
    # @return [String] Path to file.
    attr_accessor :file
    # Defines the baseline of file paths if needed.
    # @example src/main/java
    #
    # @return [String] Path baseline for git files.
    attr_accessor :baseline
    # The parser implementation of the given :format.
    #
    # @return [Parser] Parser implementation
    attr_reader :parser
    attr_reader :issues

    def initialize(danger)
      @danger = danger
      @inline = DEFAULT_INLINE
      @filter = DEFAULT_FILTER
      @fail_error = DEFAULT_FAIL
      @issues = []
    end

    # Start generating the reporter.
    # Evaluate, parse and comment the found issues.
    def report
      validate
      parse
      filter_issues
      comment
    end

    # Return the name of this reporter.
    # The name can have 3 values:
    #   - The name set using #name=
    #   - If name is not set, the name of the parser
    #
    # @return [String] Name of the reporter.
    def name
      result = @name
      result || "#{default_name} #{DEFAULT_SUFFIX}"
    end

    def default_name
      raise "#{self.class.name}#default_name must be overridden."
    end

    def default_format
      raise "#{self.class.name}#default_format must be overridden."
    end

    protected

    # Reporter implementations must provide a hash list of available parsers.
    #
    # @return [Hash<Symbol, Parser>] Hash of format symbols against their implementation.
    def parsers
      raise "#{self.class.name}#parsers must be overridden."
    end

    private

    def find_parser
      key = @format || default_format
      parser = parsers[key]
      raise(format(ERROR_NOT_SUPPORTED, key)) if parser.nil?

      parser.new
    end

    def filter_issues
      return unless filter

      git_files = @danger.git.modified_files + @danger.git.added_files
      @issues.select! do |issue|
        git_files.include?(issue_filename(issue))
      end
    end

    def issue_filename(item)
      result = +''
      if baseline
        result << baseline
        result << '/' unless baseline.chars.last == '/'
      end
      result << item.file_name
    end

    def validate
      raise ERROR_FILE_NOT_SET if @file.nil?
    end

    def parse
      @parser = find_parser
      @parser.parse(file)
      @issues = @parser.issues
    end

    def comment
      return if @issues.empty?

      inline ? inline_comment : markdown_comment
    end

    # Create and post inline reports containing all found issues.
    def inline_comment
      @issues.each do |issue|
        text = MessageUtil.inline(issue)
        if fail_error && high_issue?(issue)
          @danger.fail(text, line: issue.line, file: issue.file_name)
        else
          @danger.warn(text, line: issue.line, file: issue.file_name)
        end
      end
    end

    # Create and post a markdown reporter containing all found issues.
    def markdown_comment
      text = MessageUtil.markdown(name, @issues)
      @danger.markdown(text)
      @danger.fail(format(ERROR_HIGH_SEVERITY, name)) if fail_error && high_issues?
    end

    # Check if the issues contain any high severity item.
    #
    # @return [Bool] Found high severity or not.
    def high_issues?
      result = false
      @issues.each do |issue|
        result = true if high_issue?(issue)
      end
      result
    end

    # Check if the given issue has a high severity.
    #
    # @param issue [Issue] Issue to check.
    # @return [Bool] Is severity high or not.
    def high_issue?(issue)
      issue.severity.eql?(:high)
    end
  end
end
