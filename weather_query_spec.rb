require 'rspec'
require_relative 'weather_query'

describe 'WeatherQuery' do
  describe '.forecast' do
    context 'network errors' do
      let(:custom_error) { WeatherQuery::NetworkError }

      before do
        expect(Net::HTTP).to receive(:get)
          .and_raise(err_to_raise)
      end

      context 'timeouts' do
        let(:err_to_raise) { Timeout::Error }

        it 'handles the error' do
          expect {
            WeatherQuery.forecast('Antartica')
          }.to raise_error(custom_error, 'Request timed out')
        end
      end

      context 'invalid URI' do
        let(:err_to_raise) { URI::InvalidURIError }

        it 'handles the error' do
          expect {
            WeatherQuery.forecast('Antartica')
          }.to raise_error(custom_error, 'Bad place name: Antartica')
        end
      end

      context 'socket errors' do
        let(:err_to_raise) { SocketError }

        it 'handles the error' do
          expect {
            WeatherQuery.forecast('Antartica')
          }.to raise_error(custom_error, /Could not reach http:\/\//)
        end
      end
    end
  end
end
