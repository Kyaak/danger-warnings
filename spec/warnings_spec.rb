require File.expand_path('spec_helper', __dir__)

module Danger
  describe Danger::DangerWarnings do
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

        # mock the PR data
        # you can then use this, eg. github.pr_author, later in the spec
        # json = File.read(File.dirname(__FILE__) + '/support/fixtures/github_pr.json') # example json: `curl https://api.github.com/repos/danger/danger-plugin-template/pulls/18 > github_pr.json`
        # allow(@my_plugin.github).to receive(:pr_json).and_return(json)
      end
    end
  end
end
