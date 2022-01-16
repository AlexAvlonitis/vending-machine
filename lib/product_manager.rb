class ProductManager
  class OutOfStockError < StandardError; end
  class ItemUnavailableError < StandardError; end

  attr_reader :products_bucket

  def initialize
    @products_bucket = {}
  end

  def add_products(products)
    products.each { |product| (products_bucket[product.name] ||= []) << product }
  end

  def select_product(name)
    check_availability!(name)

    products_bucket[name].first
  end

  def remove_product(name)
    check_availability!(name)

    products_bucket[name].pop
  end

  private

  def check_availability!(name)
    raise ItemUnavailableError if unavailable?(name)
    raise OutOfStockError      if out_of_stock?(name)
  end

  def unavailable?(name)
    products_bucket[name].nil?
  end

  def out_of_stock?(name)
    products_bucket[name].empty?
  end
end
