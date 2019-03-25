Rails.application.routes.draw do

  

  # devise_for :users


  devise_for :users, controllers:
  { sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks',
    confirmations: 'users/confirmations' }


 namespace :admin do

    get 'base/index'
  resources :products
  resources :orders
end


   root 'pages#index'

   get 'shop' => 'pages#shop'

   get 'seller' => 'products#seller'

   get 'about' => 'pages#about'

   resources :listings

   resources :carts
   resources :product_items

   resources :orders


   resources :contacts
end
