require 'json'
require 'abstract_method'

module Warnings
  # Base parser class to define common methods.
  class Parser
    ERROR_FILE_NOT_EXIST = 'File \'%s\' does not exist.'.freeze
    ERROR_EXT_NOT_SUPPORTED = 'File extension \'%s\' is not supported for parser %s.'.freeze
    # All issues found by the parser.
    #
    # @return [Array<Issue>]
    attr_accessor :issues
    # Defines all supported file types for the parser.
    #
    # @return [Array<Symbol>] Array of file types.
    abstract_method :file_types
    # Execute the parser.
    # Read the file and create an array of issues.
    #
    # @return [Array<Issue>] Array of issues.
    abstract_method :parse
    # Define a default name for the parser implementation.
    #
    # @return [String] Name of the parser implementation.
    abstract_method :name

    def initialize
      @issues = []
    end

    protected

    # Parse a file as json content.
    #
    # @param file_path [String] Path to a file to be read as json.
    # @return [String] Hash of json values.
    def json(file_path)
      content = read_file(file_path)
      JSON.parse(content)
    end

    private

    # Evaluate and read the file into memory.
    #
    # @param file_path [String] Path to a file to be read.
    # @raise If file does not exist or ist empty.
    # @return [String] File content.
    def read_file(file_path)
      check_extname(file_path)
      raise(format(ERROR_FILE_NOT_EXIST, file_path)) unless File.exist?(file_path)

      File.read(file_path)
    end

    # Evaluate the files extension name.
    #
    # @param file_path [String] Path to a file to be evaluated.
    # @raise If file extension is not supported by the current parser.
    def check_extname(file_path)
      ext = File.extname(file_path).delete('.')
      raise(format(ERROR_EXT_NOT_SUPPORTED, ext, self.class.name)) unless file_types.include?(ext.to_sym)
    end
  end
end
