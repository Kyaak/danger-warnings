module Warnings
  # Defines severity levels and provides helper methods.
  class Severity
    SEVERITIES = %i(low medium high).freeze

    def self.valid?(value)
      key = value
      key = value.to_sym if value.method_exists?(:to_sym)
      SEVERITIES.include?(key)
    end
  end
end
