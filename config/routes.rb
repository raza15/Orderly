Rails.application.routes.draw do
  resources :sessions
  resources :orders
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'sessions#new'

  get '/whichpayment', to: 'sessions#whichpayment'
  get '/creditpayment', to: 'sessions#creditpayment'
  get '/end_transaction', to: 'sessions#end_transaction'
  get '/magic', to: 'sessions#magic'
end
