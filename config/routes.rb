Rails.application.routes.draw do
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  root 'sites#index'
  get '/logout', to: 'sessions#destroy'
end
