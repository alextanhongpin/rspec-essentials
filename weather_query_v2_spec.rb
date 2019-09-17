require 'rspec'
require_relative 'weather_query_v2'

describe WeatherQuery do
  describe 'caching' do
    let(:json_response) do
      '{"weather" : {"description": "Sky is Clear"}}'
    end

    before do
      expect(WeatherQuery).to receive(:http).once.and_return(json_response)
    end

    after do
      WeatherQuery.instance_variable_set(:@cache, nil)
    end

    it 'stores results in local cache' do
      actual = WeatherQuery.send(:cache)
      expect(actual).to eq({})

      WeatherQuery.forecast('Malibu,US')
      actual = WeatherQuery.send(:cache)
      expect(actual.keys).to eq(['Malibu,US'])
      expect(actual['Malibu,US']).to be_a(Hash)
    end

    it 'uses cached result in subsequent queries' do
      WeatherQuery.forecast('Malibu,US')
      WeatherQuery.forecast('Malibu,US')
      WeatherQuery.forecast('Malibu,US')
    end

    context 'skip cache' do
      before do
        expect(WeatherQuery).to receive(:http).with('Beijing,CN').and_return(json_response)
        expect(WeatherQuery).to receive(:http).with('Delhi,IN').and_return(json_response)
      end

      it 'hits API when false passed as second argument' do
        WeatherQuery.forecast('Malibu,US') # Uses cache.
        WeatherQuery.forecast('Beijing,CN', false)
        WeatherQuery.forecast('Delhi,IN', false)

        actual = WeatherQuery.send(:cache).keys
        expect(actual).to eq(['Malibu,US'])
      end
    end
  end

  # describe 'query history' do
  #   before do
  #     expect(WeatherQuery.history).to eq([])
  #     allow(WeatherQuery).to receive(:http).and_return('{}')
  #   end
  #   after do
  #     WeatherQuery.instance_variable_set(:@history, nil)
  #   end
  #
  #   it 'stores every place requested' do
  #     places =
  #   end
  # end
end
