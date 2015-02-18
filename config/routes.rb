Rails.application.routes.draw do
  match '/', to: 'sites#load', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  root 'sites#index'
  get '/logout', to: 'sessions#destroy'
  get '/auth/dropbox', to: 'sessions#new'
  resources :sites
end
