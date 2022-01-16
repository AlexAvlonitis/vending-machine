require_relative './product_manager'
require_relative './coin_manager'
require_relative './product'
require_relative './coin'
require_relative './vending_machine'
require_relative './transaction'

class VendingMachineFactory
  class << self
    def build
      coin_manager    = CoinManager.new
      product_manager = ProductManager.new
      transaction     = Transaction.new

      add_products!(product_manager)
      add_coins!(coin_manager)

      VendingMachine.new(product_manager, coin_manager, transaction)
    end

    private

    def add_products!(product_manager)
      cokes = (1..5).to_a.map { Product.new(:coke, 200) }
      pepsis = (1..5).to_a.map { Product.new(:pepsi, 150) }
      product_manager.add_products(cokes + pepsis)
    end

    def add_coins!(coin_manager)
      coins1 = (1..5).to_a.map { Coin.new(1) }
      coins2 = (1..10).to_a.map { Coin.new(2) }
      coins5 = (1..3).to_a.map { Coin.new(5) }
      coins10 = (1..5).to_a.map { Coin.new(10) }
      coins50 = (1..4).to_a.map { Coin.new(50) }
      coins100 = (1..6).to_a.map { Coin.new(100) }
      coins200 = (1..6).to_a.map { Coin.new(200) }
      all_coins = coins1 + coins2 + coins5 + coins10 + coins50 + coins100 + coins200
      coin_manager.add_coins(all_coins)
    end
  end
end
