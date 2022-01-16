class VendingMachine
  attr_reader :product_manager, :coin_manager, :transaction

  def initialize(product_manager, coin_manager, transaction)
    @product_manager = product_manager
    @coin_manager    = coin_manager
    @transaction     = transaction
  end

  def show_products
    product_manager.products_bucket
  end

  def select_product(name)
    product = product_manager.select_product(name)
    transaction.create(product)
    product
  end

  def insert_coin(coin)
    transaction.add_coin(coin)
  end

  def vend
    if transaction.total_amount >= transaction.product.price
      complete_transaction
    else
      raise 'You need to add more coins'
    end
  end

  def cancel_process
    transaction.cancel
  end

  def load_coins(coins = [])
    coin_manager.add_coins(coins)
  end

  def coins_total_amount
    coin_manager.total_amount
  end

  def load_products(products = [])
    product_manager.add_products(products)
  end

  private

  def complete_transaction
    coin_manager.add_coins(transaction.coins)
    change = issue_change!
    removed_product = product_manager.remove_product(transaction.product.name)
    transaction.complete_transaction
    [removed_product, change]
  rescue CoinManager::NotEnoughChangeError
    returned_coins = transaction.coins
    transaction.cancel
    [nil, returned_coins]
  end

  def issue_change!
    coin_manager.deduct(transaction.total_amount - transaction.product.price)
  end
end
