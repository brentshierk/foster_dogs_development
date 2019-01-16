Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'users#new'

  resources :survey_responses, only: [:create]

  resources :users, only: [:new, :create] do
    collection do
      get 'thanks'
    end
  end

  resources :organization, param: :slug do
    resource :survey, only: [:show]
  end

  namespace :admin do
    resources :outreaches do
      collection do
        post 'build'
      end
    end

    resources :organizations, only: :show, param: :slug do
      resources :users, except: [:new, :create] do
        collection do
          get 'search'
          get 'show_filters'
          post 'download_csv'
        end

        resources :outreaches, only: :destroy
        resources :notes, only: :create
      end
    end
  end

  get 'admin' => 'admin/users#index'
end
