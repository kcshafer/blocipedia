Rails.application.routes.draw do

  get '/upgrade/:id', to: 'upgrade#index', as: :upgrade
  post 'upgrade/upgrade'
  post '/downgrade', to: 'upgrade#downgrade'

  get '/my_wikis', to: 'wikis#my_wikis'
  
  resources :wikis 

  devise_for :users

  root 'welcome#index'
end
