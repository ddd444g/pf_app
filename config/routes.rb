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

  # 行きたい場所ともう一度行きたい場所一覧を表示するページ
  get "plans/:id/place_and_once_again_place", to: "plans#place_and_once_again_place", as: "place_and_once_again_place"

  # 行きたい場所に登録されている場所をplan_placeに登録するページ
  get "plans/:id/from_place_to_plan_place", to: "plans#from_place_to_plan_place", as: "from_place_to_plan_place"

  # 行きたい場所に登録されている場所をplan_placeに登録する処理
  post "from_place_to_plan_place_create", to: "plan_places#from_place_to_plan_place_create"

  # もう一度行きたいに登録されている場所をplan_placeに登録するページ
  get "plans/:id/from_once_again_place_to_plan_place", to: "plans#from_once_again_place_to_plan_place", as: "from_once_again_place_to_plan_place"

  # もう一度行きたいに登録されている場所をplan_placeに登録する処理
  post "from_once_again_place_to_plan_place_create", to: "plan_places#from_once_again_place_to_plan_place_create"

  # 自分が投稿したおすすめ場所を表示するページ
  get "my_post_recommend_places", to: "recommend_places#my_post_index"

  resources :users
  resources :places
  resources :gone_places
  resources :recommend_places
  resources :plans
  resources :plan_places

  root "home#top"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
