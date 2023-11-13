class Api::V1::StockController < ApplicationController
  def price
    api_key = ENV["stock_api_key"]
    client = LatestStockPrice::Client.new(api_key)
    response_json(client.get_price(params[:indices], params[:identifier]))
  end

  def prices
    api_key = ENV["stock_api_key"]
    client = LatestStockPrice::Client.new(api_key)
    response_json(client.get_price(params[:indices], params[:identifier]))
  end

  def price_all
    api_key = ENV["stock_api_key"]
    client = LatestStockPrice::Client.new(api_key)
    response_json(client.get_price_all(params[:identifier]))
  end
end

