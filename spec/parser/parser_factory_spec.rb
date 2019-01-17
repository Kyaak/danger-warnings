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

      context 'bandit' do
        it 'symbol' do
          result = ParserFactory.create(:bandit)
          expect(result).not_to be_nil
          expect(result).to be_a(BanditParser)
        end

        it 'string' do
          result = ParserFactory.create('bandit')
          expect(result).not_to be_nil
          expect(result).to be_a(BanditParser)
        end
      end
    end
  end
end
