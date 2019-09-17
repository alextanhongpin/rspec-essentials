class Customer
  def initialize(opts)
    # Assume opts = { discounts: { a: 0.1, b: 0.2 } }
    @discounts = opts[:discounts]
  end

  def has_discount_for?(product_code)
    @discounts.has_key?(product_code)
  end

  def discount_amount_for(product_code)
    @discounts[product_code] || 0
  end
end
