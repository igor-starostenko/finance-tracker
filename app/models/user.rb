# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def full_name
    return "#{first_name} #{last_name}".strip if first_name || last_name
    'Anonymous'
  end

  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  def under_stock_limit?
    user_stocks.count < 10
  end

  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end

  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count.zero?
  end

  def except_current_user(users)
    users.reject { |user| user.id == id }
  end

  def self.search(param)
    return User.none if param.blank?
    param.strip!
    param.downcase!
    (matches(:first_name, param) + matches(:last_name, param)).uniq
  end

  def self.matches(field_name, param)
    where("lower(#{field_name}) like ?", "%#{param}%")
  end
end
