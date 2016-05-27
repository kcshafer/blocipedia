Rails.application.routes.draw do

  get '/my_wikis', to: 'wikis#my_wikis'
  
  resources :upgrade

  resources :wikis 

  devise_for :users

  root 'welcome#index'
end
