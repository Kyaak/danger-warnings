module Warnings
  module Assets
    ASSETS_DIR = Pathname.new(File.expand_path('../assets', __dir__))
    EMPTY_FILE = "#{ASSETS_DIR}/empty.txt".freeze

    BANDIT_JSON = "#{ASSETS_DIR}/bandit.json".freeze
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_empty.json".freeze
    BANDIT_MISSING_RESULTS = "#{ASSETS_DIR}/bandit_missing_results.json".freeze
    PYLINT_TXT = "#{ASSETS_DIR}/pylint.txt".freeze
    RUBOCOP_JSON = "#{ASSETS_DIR}/rubocop.json".freeze
    RUBOCOP_MULTI_JSON = "#{ASSETS_DIR}/rubocop_multi_offenses.json".freeze

    BANDIT_FIRST_ISSUE = {
      code: "2852         except ImportError:\n2853             import pickle\n2854         with open(filename, 'wb') as outf:\n",
      filename: 'example/ply/yacc_1.py',
      issue_confidence: 'HIGH',
      issue_severity: :low,
      issue_text: 'Consider possible security implications associated with pickle module.',
      line_number: 2853,
      line_range: [
        2853
      ],
      more_info: 'https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b403-import-pickle',
      test_id: 'B403',
      test_name: 'blacklist'
    }.freeze

    PYLINT_FIRST_ISSUE = {
      filename: 'test_project/__init__.py',
      line: '1',
      category: 'F403',
      message: "'from test_project import *' used; unable to detect undefined names"
    }.freeze

    RUBOCOP_FIRST_ISSUE = {
      path: 'spec/lib/danger/danger_core/plugins/dangerfile_gitlab_plugin_spec.rb',
      offenses: [
        {
          severity: 'convention',
          message: 'Do not use semicolons to terminate expressions.',
          cop_name: 'Style/Semicolon',
          corrected: false,
          location: {
            line: 82,
            column: 65,
            length: 1
          }
        }
      ]
    }.freeze
  end
end
