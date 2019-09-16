require 'rspec'
require_relative 'address_validator'

describe AddressValidator do
  let(:address) { {street: street, city: city} }
  let(:street) { '123 Any Street' }
  let(:city) { 'Anytown' }

  it "valid? returns false for incomplete address" do
    expect(AddressValidator.valid?(address)).to eq(false)
  end

  context "address contains invalid characters" do
    let(:address) { "$123% A^ St., Anytown, CA, USA, 12345" }
    it "valid? returns false for incomplete address" do
      expect(AddressValidator.valid?(address)).to eq(false)
    end
  end

  context "address is a String" do
    let(:address) { "123 Any St., Anytown" }

    it "valid? returns false for incomplete address" do
      expect(AddressValidator.valid?(address)).to eq(false)
    end
  end

  context "complete address" do
    # We define 'address' as a hash, but with all values.
    let(:address) do 
      {
        street: '123 Any Street',
        city: 'Anytown',
        region: 'Anyplace',
        country: 'Anyland',
        postal_code: '123456'
      }
    end

    it 'valid? return true' do
      expect(AddressValidator.valid?(address)).to eq(true)
    end

    context "address is a String" do
      let(:address) { "123 Any St., Anytown, CA, USA, 12345" }
      it "valid? returns true" do
        expect(AddressValidator.valid?(address)).to eq(true)
      end
    end
  end

  it "missing_parts returns an array of missing required parts" do
    expect(AddressValidator.missing_parts(address)).to eq([:region, :postal_code, :country])
  end

  context "invalid character in value" do
    let(:city) {"Any$town"}
    
    it "invalid part returns keys with invalid values do" do
      expect(AddressValidator.invalid_parts(address)).to eq([:city])
    end
  end
end
