require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerWarnings do
    ASSETS_DIR = File.expand_path('assets', __dir__)
    BANDIT_EMPTY = "#{ASSETS_DIR}/bandit_empty.json".freeze
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
      end
    end
  end
end
