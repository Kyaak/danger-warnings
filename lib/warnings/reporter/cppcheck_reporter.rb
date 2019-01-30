# frozen_string_literal: true

require_relative 'reporter'
require_relative '../parser/cppcheck_xml_parser'

module Warnings
  # Reporter implementation for Cppcheck.
  class CppcheckReporter < Reporter
    NAME = 'Cppcheck'

    def parsers
      {
        xml: CppcheckXmlParser
      }
    end

    def default_name
      NAME
    end

    def default_format
      :xml
    end
  end
end
