# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :admin_user do
    mount Sidekiq::Web => '/sidekiq'
  end
  root to: "admin/dashboard#index"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      namespace :admin do
        get 'dashboard/user_detail', to: 'dashboard#user_detail'
      end

      resources :chats, only: [:create] do
        get :chat_list, on: :collection
        get :history, on: :collection
        put :read_messages
        get :chat_list_unread, on: :collection
        get :check_unread_chats, on: :collection
        put :clear_chats
        put :delete_chat
      end

      post 'sign_up', to: 'users#create'
      put 'resend_otp', to: 'users#resend_otp'
      namespace :users do
        patch 'update_profile', to: 'profile#update'
        patch 'deactivate', to: 'profile#deactivate'
        get 'profile', to: 'profile#show'
        resources :contact_us, only: %i[create update]
      end
      resources :meetups do
        get :sent_invites, on: :collection
        post :give_feedback, on: :member
      end
      resources :relationships do
        delete :unblock_couple,on: :collection
      end
      resources :users do
        resource :couple_profile
        member do
          post :remove_image, to: 'couple_profiles#remove_image'
          get :images, to: 'couple_profiles#images'
          post :invite_partner
        end
        collection do
          post :add_image, to: 'couple_profiles#add_image'
          get :matches
          post :sign_up_as_partner
          post 'login'
          get 'profile'
          post :irrelevant_matches
          post 'matchlist_timer'
          post :suggest_activity
          get :application_config
        end
      end
      resources :couple_profile, only: [] do
        patch :go_incognito, to: 'couple_profiles#go_incognito', on: :collection
        patch :use_spotlight, to: 'couple_profiles#use_spotlight', on: :collection
        post :refresh_match_list, to: 'couple_profiles#refresh_match_list', on: :collection
        post :change_location, to: 'couple_profiles#change_location', on: :collection
        get :get_location, to: 'couple_profiles#get_location', on: :collection
        get :current_profile, to: 'couple_profiles#current_profile', on: :collection
      end
      resource :wallet, only: [] do
        post 'add_money'
        get 'balance'
        get 'transactions'
        get 'onboarding_reward_collected'
      end

      resource :configuration, only: [] do
        get 'earn'
        get 'burn'
      end
      resources :faqs, only: [:index]
      resources :coin_packages, only: [:index]
      resources :splash_screens, only: [:index]
      resources :todo_details, only: [:index]
      resources :banners, only: [:index]
      resources :personality_traits_icons, only: [:index]
      resources :spend_free_time_icons, only: [:index]
      resources :burn_coins_features, only: [:index]

      resources :mobile_devices, only: [:create] do
        delete :delete_mobile_device, on: :collection
      end

    end
  end

  resource :chat_test do
    post 'connect'
  end
end
