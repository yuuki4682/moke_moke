Rails.application.routes.draw do

  devise_for :users, controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }
  
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  } 
  #ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end
  
  #ユーザー側ルート設定
  scope module: :public do
    root to: "homes#top"
    get "about" => "homes#about", as: :about
    resources :users, only: [:show, :edit, :update] do
      resources :chats, only: [:show, :create, :destroy]
      resources :relationships, only: [:create, :destroy]
      get "followings" => "relationships#followings", as: :followings
      get "followers" => "relationships#followers", as: :followers
      resources :likes, only: [:index] #ユーザーがいいねした一覧
    end
    get 'mypage' => 'users#mypage', as: :mypage
    resources :works do
      resources :comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
    end
    resources :notifications, only: [:index]
    get "search" => "search#search", as: :search
    get "tags/:id" => "tags#search", as: :tag_search
  end
  
  #管理者側ルート設定
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :report, only: [:index]
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
