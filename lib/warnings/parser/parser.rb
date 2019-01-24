require 'json'

module Warnings
  # Base parser class to define common methods.
  class Parser
    ERROR_FILE_NOT_EXIST = 'File <%s> does not exist.'.freeze
    ERROR_EXT_NOT_JSON = '%s is not a json file.'.freeze
    EXT_JSON = 'json'.freeze
    # All issues found by the parser.
    #
    # @return [Array<Issue>] Array of issues.
    attr_accessor :issues

    def initialize
      @issues = []
    end

    # Execute the parser.
    # Read the file and create an array of issues.
    #
    # @param file [String] Path to file.
    # @return [Array<Issue>] Array of issues.
    def parse(file)
      raise "#{self.class.name}#parse(file) must be overridden.\n#{file}"
    end

    protected

    # Check if the file is a json file.
    #
    # @param file_path [String] Path to a file to be read as json.
    # @return [Bool] Whether the file is a json or not.
    def json?(file_path)
      File.extname(file_path).delete('.').downcase.eql?(EXT_JSON)
    end

    # Parse a file as json content.
    #
    # @param file_path [String] Path to a file to be read as json.
    # @return [String] Hash of json values.
    def json(file_path)
      raise(format(ERROR_EXT_NOT_JSON, file_path)) unless json?(file_path)

      content = read_file(file_path)
      JSON.parse(content)
    end

    # Read the file into memory and serve each line.
    #
    # @param file_path [String] Path to a file to be read.
    # @raise If file does not exist.
    # @return [String] Array of line contents.
    def read_lines(file_path)
      raise(format(ERROR_FILE_NOT_EXIST, file_path)) unless File.exist?(file_path)

      File.readlines(file_path, chomp: true)
    end

    private

    # Evaluate and read the file into memory.
    #
    # @param file_path [String] Path to a file to be read.
    # @raise If file does not exist or ist empty.
    # @return [String] File content.
    def read_file(file_path)
      raise(format(ERROR_FILE_NOT_EXIST, file_path)) unless File.exist?(file_path)

      File.read(file_path)
    end
  end
end
