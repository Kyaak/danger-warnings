require_relative 'spec_helper'
require_relative '../lib/warnings/reporter'

module Warnings
  describe Reporter do
    before do
      @reporter = Reporter.new
    end

    context '#name' do
      it 'returns default' do
        expect(@reporter.name).to eq(Reporter::DEFAULT_NAME)
      end

      context 'set' do
        TEST_NAME = 'My Test Name Report'.freeze

        before do
          @reporter.name = TEST_NAME
        end

        it 'without parser' do
          expect(@reporter.parser).to be_nil
          expect(@reporter.name).to eq(TEST_NAME)
        end

        it 'with parser' do
          @reporter.parser = :bandit
          expect(@reporter.parser).not_to be_nil
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.name).to eq(TEST_NAME)
        end
      end

      context 'not set' do
        it 'without parser' do
          expect(@reporter.parser).to be_nil
          expect(@reporter.parser_impl).to be_nil
          expect(@reporter.name).to eq(Reporter::DEFAULT_NAME)
        end

        it 'with parser' do
          @reporter.parser = :bandit
          expect(@reporter.parser).not_to be_nil
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.name).to eq("#{BanditParser::NAME} #{Reporter::DEFAULT_NAME}")
        end
      end
    end

    context '#parser' do
      context 'valid name' do
        it 'sets #parser and #parser_impl' do
          @reporter.parser = :bandit
          expect(@reporter.parser).to eq(:bandit)
          expect(@reporter.parser_impl).not_to be_nil
          expect(@reporter.parser_impl).to be_a(BanditParser)
        end
      end

      context 'invalid name' do
        it 'setter raises error' do
          expect { @reporter.parser = :unknown }.to raise_error
        end
      end
    end
  end
end
