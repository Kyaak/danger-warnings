require_relative 'reporter'
require_relative '../parser/bandit_json_parser'

module Warnings
  # Reporter implementation for Bandit.
  class BanditReporter < Reporter
    NAME = 'Bandit'.freeze

    def parsers
      {
        json: BanditJsonParser
      }
    end

    def default_name
      NAME
    end

    def default_format
      :json
    end
  end
end
