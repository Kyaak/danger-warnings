require File.expand_path('spec_helper', __dir__)
require_relative 'spec_helper/assets'

module Danger
  describe Danger::DangerWarnings do
    ASSETS_DIR = File.expand_path('assets', __dir__)
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_json_empty.json".freeze
    BANDIT_FILE = "#{ASSETS_DIR}/bandit.json".freeze

    it 'should be a plugin' do
      expect(Danger::DangerWarnings.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.warnings

        @dangerfile.git.stubs(:modified_files).returns(%w())
        @dangerfile.git.stubs(:added_files).returns(%w())
      end

      it 'runs bandit reporter' do
        @my_plugin.report(
          id: :bandit,
          format: :json,
          file: Warnings::Assets::BANDIT_JSON,
          filter: false,
          inline: true
        )
        expect(@dangerfile.status_report[:warnings]).not_to be_empty
      end
    end
  end
end
