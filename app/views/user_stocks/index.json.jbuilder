# frozen_string_literal: true

json.array! @user_stocks, partial: 'user_stocks/user_stock', as: :user_stock
