Rails.application.routes.draw do
  get "login", to: "users#login_form"
  post "login", to: "users#login"
  post "logout", to: "users#logout"
  post 'guest_login', to: "users#guest_login"
  resources :users
  resources :places
  resources :gone_places
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
