require 'spec_helper'
require_relative '../../lib/vending_machine_factory'
require_relative '../../lib/transaction'
require_relative '../../lib/coin'

describe 'Vending Machine' do
  vm = VendingMachineFactory.build

  coin200 = Coin.new(200)
  coin100 = Coin.new(100)
  coin1   = Coin.new(1)

  coke    = Product.new(:coke, 200)
  pepsi   = Product.new(:pepsi, 150)

  context 'Once a product is selected' do
    context 'And the appropriate amount of money is inserted' do
      it 'returns the correct product' do
        vm.select_product(:coke)
        vm.insert_coin(coin200)
        product = vm.vend
        expect(product[0].name).to eq :coke
        expect(product[1]).to eq :no_change
      end

      it 'reduces product count by 1' do
        vm.select_product(:coke)
        vm.insert_coin(coin200)
        coke_count = vm.product_manager.products_bucket[:coke].count
        vm.vend
        expect(vm.product_manager.products_bucket[:coke].count)
          .to eq(coke_count - 1)
      end

      it 'adds coins to the storage' do
        vm.select_product(:coke)
        vm.insert_coin(coin200)
        coins_count = vm.coin_manager.coins_bucket[coin200.value].count
        vm.vend
        expect(vm.coin_manager.coins_bucket[coin200.value].count)
          .to eq(coins_count + 1)
      end
    end

    context 'when less amount of money are inserted' do
      it 'raises error to add more coins' do
        vm.select_product(:coke)
        vm.insert_coin(coin1)
        expect { vm.vend }.to raise_error('You need to add more coins')
      end
    end

    context 'when more amount of money are inserted' do
      it 'returns the product and change' do
        vm.cancel_process # Cancel previous transaction
        vm.select_product(:pepsi)
        vm.insert_coin(coin200)
        product = vm.vend
        expect(product[0].name).to eq :pepsi
        expect(product[1].sum(&:value)).to eq 50
      end
    end
  end

  describe 'Loads coins when the machine is running' do
    vm = VendingMachineFactory.build

    it 'can load coins' do
      vm.load_coins([coin200])
      total_before = vm.coins_total_amount

      vm.load_coins([coin200])
      expect(vm.coins_total_amount).to eq total_before + 200
    end
  end

  describe 'Loads products when the machine is running' do
    vm = VendingMachineFactory.build

    it 'can load products' do
      total_before = vm.show_products[:coke].count

      vm.load_products([coke])
      expect(vm.show_products[:coke].count).to eq total_before + 1
    end
  end
end
