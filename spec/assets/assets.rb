module Warnings
  module Assets
    ASSETS_DIR = Pathname.new(File.expand_path('.', __dir__))
    BANDIT_JSON = "#{ASSETS_DIR}/bandit.json".freeze
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_empty.json".freeze
    BANDIT_MISSING_RESULTS = "#{ASSETS_DIR}/bandit_missing_results.json".freeze
  end
end
