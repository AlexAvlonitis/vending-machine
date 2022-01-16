class Transaction
  attr_reader :product, :coins

  def initialize
    @product = nil
    @coins   = []
  end

  def create(item)
    @product = item
  end

  def add_coin(coin)
    return unless coin

    @coins << coin
    total_amount
  end

  def complete_transaction
    clear_transaction
  end

  def cancel
    clear_transaction
  end

  def total_amount
    coins.sum(&:value)
  end

  private

  def clear_transaction
    @product = nil
    @coins   = []
  end
end
