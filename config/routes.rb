Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do

      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      get '/current_user', to: 'sessions#current_user'

      get '/stock/price' => 'stock#price'
      get '/stock/prices' => 'stock#prices'
      get '/stock/price_all' => 'stock#price_all'

      post '/transfer/deposit' => 'transaction#create_deposit'
      post '/transfer/withdraw' => 'transaction#create_withdrawal'
      post '/transfer/transfer' => 'transaction#create_transfer'

      post '/wallet/create' => 'wallet#create_wallet'
      get '/wallet/balance' => 'wallet#get_balance'

    end
  end
end
