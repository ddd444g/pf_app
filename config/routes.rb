Rails.application.routes.draw do
  resources :users
  resources :places
  resources :gone_places
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
