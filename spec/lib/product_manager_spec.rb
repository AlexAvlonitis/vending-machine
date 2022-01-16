require 'spec_helper'
require 'product_manager'

describe ProductManager do
  let(:subject) { described_class.new }

  let(:coke) { double(:coke, name: :coke, price: 200) }
  let(:coke2) { double(:coke, name: :coke, price: 200) }

  describe '#add_products' do
    context 'when an item does not exist in the products list' do
      it 'adds it' do
        subject.add_products([coke, coke2])
        expect(subject.products_bucket).to eq({ coke: [coke, coke2] })
      end
    end
  end

  describe '#select_product' do
    context 'when an item is available' do
      it 'returns it' do
        subject.add_products([coke, coke2])
        expect(subject.select_product(:coke)).to eq coke
      end
    end

    context 'when an item does not exist at all' do
      it 'raises unavailable error' do
        expect { subject.select_product(:coke) }
          .to raise_error(ProductManager::ItemUnavailableError)
      end
    end

    context 'when an item is out of stock' do
      it 'raises out of stock error' do
        allow(subject).to receive(:products_bucket) { { coke: [] } }

        expect { subject.select_product(:coke) }
          .to raise_error(ProductManager::OutOfStockError)
      end
    end
  end

  describe '#remove_product' do
    context 'when an item is available' do
      it 'removes it' do
        subject.add_products([coke])
        subject.remove_product(:coke)
        expect(subject.products_bucket[:coke]).to be_empty
      end
    end

    context 'when an item does not exist at all' do
      it 'raises unavailable error' do
        expect { subject.remove_product(:coke) }
          .to raise_error(ProductManager::ItemUnavailableError)
      end
    end

    context 'when an item is out of stock' do
      it 'raises out of stock error' do
        allow(subject).to receive(:products_bucket) { { coke: [] } }

        expect { subject.remove_product(:coke) }
          .to raise_error(ProductManager::OutOfStockError)
      end
    end
  end
end
