require 'net/http'
require 'json'
require 'timeout'

module WeatherQuery
  extend self

  class NetworkError < StandardError
  end

  def forecast(place, use_cache=true)
    if use_cache
      cache[place] ||= JSON.parse(http(place))
    else
      JSON.parse(http(place))
    end
  rescue JSON::ParserError
    raise NetworkError.new('Bad response')
  end

  private

  def cache
    @cache ||= {}
  end

  BASE_URI = 'http://api.openweathermap.org/data/2.5/weather?q='

  def http(place)
    uri = URI(BASE_URI + place)

    Net::HTTP.get(uri)
  rescue Timeout::Error
    raise NetworkError.new('Request timed out')
  rescue URI::InvalidURIError
    raise NetworkError.new('Bad place name: #{place}')
  rescue SocketError
    raise NetworkError.new('Could not reach #{uri.to_s}')
  end
end
