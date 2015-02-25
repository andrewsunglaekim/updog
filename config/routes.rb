Rails.application.routes.draw do
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match '/', to: 'sites#load', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]
  root 'sites#index'
  get '/logout', to: 'sessions#destroy'
  get '/auth/dropbox', to: 'sessions#new'
  match '/*req', to: 'sites#load', constraints: { subdomain: /.+/ }, via: [:get, :post, :put, :patch, :delete]
  get '/about', to: 'pages#about'
  get '/source', to: 'pages#source'
  get '/pricing', to: 'pages#pricing'
  get '/admin', to: 'pages#admin'
  get '/webhook', to: 'webhook#challenge'
  post '/webhook', to: 'webhook#post'
  post "/versions/:id/revert", to: "versions#revert", as: "revert_version"
  resources :sites, path: '' 
end
