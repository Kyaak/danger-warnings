require_relative '../spec_helper'
require_relative '../../lib/warnings/parser/parser_factory'

module Warnings
  describe ParserFactory do
    context '#get' do
      it 'unknown symbol' do
        expect { ParserFactory.create(:unknown) }.to raise_error('Parser \'unknown\' not supported.')
      end

      it 'unknown int' do
        expect { ParserFactory.create(123) }.to raise_error('Parser \'123\' not supported.')
      end

      it 'unknown string' do
        expect { ParserFactory.create('unknown') }.to raise_error('Parser \'unknown\' not supported.')
      end

      it 'known symbol' do
        expect(ParserFactory.create(:bandit)).to be_a(BanditParser)
      end

      it 'known string' do
        expect(ParserFactory.create('bandit')).to be_a(BanditParser)
      end

      it 'bandit' do
        result = ParserFactory.create(:bandit)
        expect(result).not_to be_nil
        expect(result).to be_a(BanditParser)
      end

      it 'pylint' do
        result = ParserFactory.create(:pylint)
        expect(result).not_to be_nil
        expect(result).to be_a(PylintParser)
      end

      it 'rubocop' do
        result = ParserFactory.create(:rubocop)
        expect(result).not_to be_nil
        expect(result).to be_a(RubocopParser)
      end
    end
  end
end
