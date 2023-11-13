require 'httparty'

module LatestStockPrice
  class Client
    include HTTParty

    base_uri ENV["stock_api_base_url"]
    read_timeout = (ENV["stock_api_read_time_out"] || '30').to_i
    open_timeout = (ENV["stock_api_open_time_out"] || '30').to_i
    read_timeout(read_timeout <= 0 ? 30 : read_timeout)
    open_timeout(open_timeout <= 0 ? 30 : open_timeout)

    def initialize(api_key)
      @api_key = api_key
    end

    def get_price(indices, identifier)
      url = "/price?Indices=#{indices}"
      url.concat("&Identifier=#{identifier}") if identifier
      handle_response(url)
    end

    def get_price_all(identifier)
      url = "/any"
      url.concat("?Identifier=#{URI.encode_www_form_component(identifier)}") if identifier
      handle_response(url)
    end

    private

    def handle_response(url)
      response = self.class.get(url, headers: basic_header, debug_output: $stdout)
      return response.parsed_response, response.code
    rescue Net::ReadTimeout, Net::OpenTimeout, Errno::EINVAL, Errno::ECONNRESET, Errno::ECONNREFUSED => e
      raise Error, "API request failed with status #{response.code}: #{response.parsed_response}"
    end

    def basic_header
      {
        "Content-Type" => "application/json",
        "X-RapidAPI-Key" => ENV["stock_api_key"],
        "X-RapidAPI-Host" => ENV["stock_api_base_url"].sub("https://", ""),
      }
    end
  end
end
