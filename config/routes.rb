Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'surveys#show', organization_slug: 'foster-dogs'

  resources :survey_responses, only: [:create]

  resources :organization, param: :slug do
    resource :survey, only: [:show] do
      collection do
        get 'thanks'
      end
    end
  end

  namespace :admin do
    resources :users, except: [:new, :create] do
      collection do
        get 'search'
        get 'filters'
        post 'download_csv'
      end

      resources :outreaches, only: :destroy
      resources :notes, only: :create
    end

    resources :outreaches do
      collection do
        post 'build'
      end
    end

    resources :organizations, only: :show
  end

  get 'admin' => 'admin/users#index'
  get 'foster-dogs' => 'surveys#show', organization_slug: 'foster-dogs'
  get 'macc' => 'surveys#show', organization_slug: 'macc'
end
