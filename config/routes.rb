Rails.application.routes.draw do
  resources :users, except: [:index]

  get 'signup' => "users#new", as: :signup
  get 'login' => "users#login", as: :login
  post 'login' => "users#authenticate"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pins#index'

  get "pins/name-:slug" => "pins#show_by_name", as: 'pin_by_name'

  resources :pins

  get '/library' => 'pins#index'
end
