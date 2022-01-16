require 'spec_helper'
require 'vending_machine_factory'

describe VendingMachineFactory do
  subject { described_class }

  let(:transaction) { double(:transaction) }
  let(:coin_manager) { double(:coin_manager) }
  let(:product_manager) { double(:product_manager) }
  let(:product) { double(:product) }
  let(:coin) { double(:coin) }

  before do
    allow(Transaction).to receive(:new) { transaction }
    allow(CoinManager).to receive(:new) { coin_manager }
    allow(ProductManager).to receive(:new) { product_manager }
    allow(Product).to receive(:new) { product }
    allow(Coin).to receive(:new) { coin }

    allow(coin_manager).to receive(:add_coins)
    allow(product_manager).to receive(:add_products)
  end

  describe '.build' do
    it 'creates a vending machine object' do
      expect(subject.build).to be_an_instance_of(VendingMachine)
    end

    it 'creates a transaction object' do
      expect(Transaction).to receive(:new) { transaction }
      subject.build
    end

    it 'creates a coin_manager object' do
      expect(CoinManager).to receive(:new) { coin_manager }
      subject.build
    end

    it 'creates a product_manager object' do
      expect(ProductManager).to receive(:new) { product_manager }
      subject.build
    end

    [[:coke, 200, 5], [:pepsi, 150, 5]].each do |name, price, amount|
      it "creates #{amount} #{name} products" do
        expect(Product)
          .to receive(:new)
          .with(name, price)
          .and_return(product)
          .exactly(amount).times

        subject.build
      end
    end

    it 'adds the products to the product manager' do
      expect(product_manager)
        .to receive(:add_products)
        .with(Array.new(10, product))

      subject.build
    end

    [[1, 5], [2, 10], [5, 3], [10, 5], [50, 4], [100, 6], [200, 6]]
      .each do |value, amount|
        it "creates #{amount} #{value}p coins" do
          expect(Coin)
            .to receive(:new)
            .with(value)
            .and_return(coin)
            .exactly(amount).times

          subject.build
        end
      end

    it 'adds the coins to the coin manager' do
      expect(coin_manager)
        .to receive(:add_coins)
        .with(Array.new(39, coin))

      subject.build
    end
  end
end
