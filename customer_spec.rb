require 'rspec'
require 'rspec/expectations'

require_relative 'customer'

RSpec::Matchers.define :be_discounted do |product, discount|
  match do |customer|
    @actual = customer.discount_amount_for(product)
    @actual == discount
    # customer.discount_amount_for(product) == discount
  end

  failure_message do |customer|
    # actual = customer.discount_amount_for(product)
    "expected #{product} discount of #{discount}, got #{actual}"
  end
end

describe "product discount" do
  let(:product) { "foo123" }
  let(:discounts) { { product: 0.1 } }
  subject(:customer) { Customer.new(discounts: discounts) }
 
  it "detects when customer has a discount" do
    # actual = customer.discount_amount_for(product)
    # expect(actual).to eq(0.1)
    expect(customer).to be_discounted(product, 0.1)
  end
end
