require_relative '../spec_helper'
require_relative '../../lib/warnings/reporter/bandit_reporter'

module Warnings
  describe BanditReporter do
    before do
      @dangerfile = testing_dangerfile
      @reporter = BanditReporter.new(@dangerfile)
      @reporter.inline = true
      @reporter.filter = false

      @dangerfile.git.stubs(:modified_files).returns(%w())
      @dangerfile.git.stubs(:added_files).returns(%w())
    end

    it '#default_name' do
      expect(@reporter.default_name).to eq(BanditReporter::NAME)
    end

    it '#default_parser' do
      expect(@reporter.default_format).to eq(:json)
    end

    it 'runs default json parser' do
      @reporter.file = Assets::BANDIT_JSON
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end

    it 'runs json parser' do
      @reporter.file = Assets::BANDIT_JSON
      @reporter.format = :json
      @reporter.report
      expect(@dangerfile.status_report[:warnings]).not_to be_empty
    end
  end
end
