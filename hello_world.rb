require 'rspec'

describe 'hello world' do
  it 'returns true' do
    expect('hello world').to eq('hello world')
  end

  it 'fails' do
    expect('bye').to eq('hello world')
  end
end
