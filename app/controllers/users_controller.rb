# frozen_string_literal: true

class UsersController < ApplicationController
  def my_portfolio
    @user_stocks = current_user.user_stocks
    @user = current_user
  end

  def my_friends
    @friendships = current_user.friends
  end
end
