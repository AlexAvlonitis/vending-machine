require 'spec_helper'
require 'transaction'

describe Transaction do
  let(:subject) { described_class.new }

  let(:product) { double(:product, name: :coke, price: 100) }
  let(:coin100) { double(:coin100, value: 100) }
  let(:coin1) { double(:coin1, value: 1) }

  describe '#create' do
    it 'adds the product to the transaction' do
      subject.create(product)
      expect(subject.product).to eq product
    end
  end

  describe '#add_coin' do
    it 'adds the coin to the coins array' do
      expect(subject.add_coin(coin100)).to eq 100

    end
  end

  describe '#complete transaction!' do
    it 'clears the product' do
      subject.complete_transaction
      expect(subject.product).to eq nil
    end

    it 'clears the inserted coins' do
      subject.add_coin(coin100)
      subject.complete_transaction
      expect(subject.coins).to eq []
    end
  end

  describe '#cancel' do
    it 'clears the product' do
      subject.cancel
      expect(subject.product).to eq nil
    end

    it 'clears the inserted coins' do
      subject.add_coin(coin100)
      subject.cancel
      expect(subject.coins).to eq []
    end
  end

  describe '#total_amount' do
    it 'displays the total inserted coin amount in pence' do
      subject.add_coin(coin100)
      subject.add_coin(coin100)
      expect(subject.total_amount).to eq 200
    end
  end
end
