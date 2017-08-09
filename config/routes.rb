Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'user/registrations' }
  resources :user_stocks, except: %i[show edit update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_stocks', to: 'stocks#search'
  get 'search_stock', to: 'stocks#search_stock'
end
