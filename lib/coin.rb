class Coin
  class InvalidCoinError < StandardError; end

  ALLOWED_COINS = Set.new([1, 2, 5, 10, 20, 50, 100, 200])

  attr_reader :value

  def initialize(value)
    @value = value
    valid?(value)
  end

  private

  def valid?(value)
    raise InvalidCoinError unless ALLOWED_COINS.include?(value)
  end
end
