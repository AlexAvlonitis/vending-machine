require 'spec_helper'
require 'coin'

describe Coin do
  let(:subject) { described_class }

  let(:values) { Coin::ALLOWED_COINS }
  let(:invalid_values) { [22, 43, 12, 9, 0] }

  describe '.new' do
    context 'when coin is in the allowed list' do
      it 'creates the coin' do
        values.each do |value|
          expect(subject.new(value)).to be_an_instance_of(Coin)
        end
      end
    end

    context 'when coin is not in the allowed list' do
      it 'raises error' do
        invalid_values.each do |value|
          expect { subject.new(value) }.to raise_error(Coin::InvalidCoinError)
        end
      end
    end
  end
end
