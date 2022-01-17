class CoinManager
  class NotEnoughChangeError < StandardError; end

  attr_reader :coins_bucket

  def initialize
    @coins_bucket = {}
  end

  def deduct(amount_to_deduct)
    raise NotEnoughChangeError if amount_to_deduct > total_amount
    return :no_change if amount_to_deduct.zero?

    change = find_available_change(amount_to_deduct)
    raise NotEnoughChangeError unless change.sum(&:value) == amount_to_deduct

    remove_coins(change)
  end

  def add_coins(coins = [])
    coins.each { |coin| (coins_bucket[coin.value] ||= []) << coin }
  end

  def total_amount
    coins_bucket.sum { |amount, container| amount * container.size }
  end

  private

  def find_available_change(amount_to_deduct)
    change = []
    coins_bucket_sorted_desc = coins_bucket.sort.reverse

    coins_bucket_sorted_desc.each do |value, coins|
      next if amount_to_deduct < value

      coins_to_remove = amount_to_deduct / value
      change += coins_bucket[value].last(coins_to_remove)
      amount_to_deduct %= value
    end

    change
  end

  def remove_coins(coins = [])
    coins.map { |coin| coins_bucket[coin.value].pop }.compact
  end
end
