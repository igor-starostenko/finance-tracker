# frozen_string_literal: true

class StocksController < ApplicationController
  attr_reader :stock

  def search
    search_for_stock(params[:stock]) if params[:stock]
    # return render json: stock if stock
    return render partial: 'lookup' if stock
    render status: :not_found, nothing: true
  end

  def search_stock(ticker)
    # @stock = Stock.new_from_lookup(ticker)
    # @stock.save
  end

  private

  def search_for_stock(stock)
    @stock = Stock.find_by_ticker(params[:stock])
    @stock ||= Stock.new_from_lookup(params[:stock])
  end
end
