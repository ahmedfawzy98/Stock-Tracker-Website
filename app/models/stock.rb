class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    if StockQuote::Stock.api_key.nil?
      StockQuote::Stock.new(api_key: ENV['api_key'])
    end
    begin
      stock = StockQuote::Stock.quote(ticker_symbol)
      new(name: stock.company_name, ticker: stock.symbol,
            last_price: stock.latest_price)
    rescue Exception => e
      nil
    end
  end
end
