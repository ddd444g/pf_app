Rails.application.routes.draw do
  get "login", to: "users#login_form"
  post "login", to: "users#login"
  post "logout", to: "users#logout"

  post "guest_login", to: "users#guest_login"

  post "not_from_place_create", to: "gone_places#not_from_place_create"

  # 他人のおすすめ場所を自分の行きたい場所へ登録する処理
  post "new_from_recommend_places", to: "places#new_from_recommend_places"

  post "/gone_places/:id/once_again", to: "gone_places#once_again", as: :once_again
  post "/gone_places/:id/cancel_once_again", to: "gone_places#cancel_once_again", as: :cancel_once_again

  resources :users
  resources :places
  resources :gone_places
  resources :recommend_places
  resources :plans
  resources :plan_places

  root "home#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
