require 'spec_helper'
require 'vending_machine'
require 'transaction'

describe VendingMachine do
  let(:subject) do
    described_class.new(product_manager, coin_manager, transaction)
  end

  let(:product_manager) { double(:product_manager) }
  let(:coin_manager) { double(:coin_manager) }
  let(:transaction) { double(:transaction) }
  let(:products) { double(:products, { coke: [coke, pepsi] }) }
  let(:coke) { double(:product, name: :coke, price: 100) }
  let(:pepsi) { double(:product, name: :pepsi, price: 200) }
  let(:coins) { double(:products, { 100 => [coin100, coin200], 200 => [coin200] }) }
  let(:coin100) { double(:coin, value: 100) }
  let(:coin200) { double(:coin, value: 200) }

  before do
    allow(product_manager).to receive(:products_bucket) { products }
  end

  describe '#show_products' do
    it 'sends the message product_store to product_manager' do
      expect(product_manager).to receive(:products_bucket) { products }
      subject.show_products
    end
  end

  describe '#select_product' do
    before do
      allow(product_manager).to receive(:select_product) { coke }
      allow(transaction).to receive(:create)
    end

    it 'sends the select_product message to product_manager' do
      expect(product_manager)
        .to receive(:select_product)
        .with(:coke)
        .and_return(coke)

      subject.select_product(:coke)
    end

    it 'creates a transaction' do
      expect(transaction).to receive(:create).with(coke)
      subject.select_product(:coke)
    end

    it 'returns the selected product' do
      expect(subject.select_product(:coke)).to eq coke
    end
  end

  describe '#insert_coin' do
    it 'send the add_coin message to transaction' do
      allow(transaction).to receive(:add_coin) { 100 }
      expect(transaction).to receive(:add_coin).with(coin100)

      subject.insert_coin(coin100)
    end
  end

  describe '#cancel_process' do
    it 'sends the cancel message to transaction' do
      allow(transaction).to receive(:cancel)
      expect(transaction).to receive(:cancel)

      subject.cancel_process
    end
  end

  describe '#vend' do
    before do
      allow(coin_manager).to receive(:add_coins)
      allow(coin_manager).to receive(:deduct) { :no_change }
      allow(product_manager).to receive(:remove_product) { coke }
      allow(transaction).to receive(:complete_transaction)
      allow(transaction).to receive(:cancel)
      allow(transaction).to receive(:coins) { [coin100] }
      allow(transaction).to receive(:product) { coke }
      allow(transaction).to receive(:total_amount) { 100 }
    end

    context 'when the total amount is the same as the price of the product' do
      it 'returns the product without change' do
        expect(subject.vend).to eq [coke, :no_change]
      end
    end

    context 'when the total amount is larger than the price of the product' do
      it 'returns the product with change' do
        allow(coin_manager).to receive(:deduct) { [coin200] }
        allow(transaction).to receive(:total_amount) { 300 }

        expect(subject.vend).to eq [coke, [coin200]]
      end
    end

     context 'when the total amount is smaller than the price of the product' do
      it 'raises add more coins error' do
        allow(transaction).to receive(:product) { pepsi }
        allow(transaction).to receive(:total_amount) { 100 }

        expect { subject.vend }.to raise_error('You need to add more coins')
      end
    end

    context 'when the coin manager raises no change error' do
      it 'refunds the coins without a product' do
        allow(coin_manager).to receive(:deduct).and_raise(CoinManager::NotEnoughChangeError)
        allow(transaction).to receive(:coins) { [coin200] }

        expect(subject.vend).to eq [nil, [coin200]]
      end
    end
  end
end
