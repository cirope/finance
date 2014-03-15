Finance::Application.routes.draw do
  constraints AdminSubdomain do
    resources :accounts
  end

  constraints AccountSubdomain do
    get '/schedules(/:date)', to: 'schedules#index', as: 'schedules', constraints: { date: /\d{4}\/\d{2}\/\d{2}/ }
    get '/schedules/new(/:date)', to: 'schedules#new', as: 'new_schedule', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
    resources :schedules, only: [:show, :create, :edit, :update, :destroy] do
      patch 'mark_as_done', to: 'schedules#mark_as_done', as: 'mark_as_done', on: :member
    end

    get '/loans(/:filter)', to: 'loans#index', as: 'loans',
      constraints: { filter: 'expired|close_to_expire|not_renewed' }

    resources :loans, only: [:show, :new, :create] do
      resources :payments, only: [:edit, :update]
      resources :schedules, only: [:new, :create, :edit, :update]
    end

    # Profiles
    get 'profile', to: 'profiles#edit', as: 'profile'
    patch 'profile', to: 'profiles#update'

    # Resorces
    resources :cities
    resources :states
    resources :users
    resources :companies
    resources :tax_settings
    resources :customers
  end

  # Sessions
  get 'login', to: 'sessions#new', as: 'login'
  post 'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  resources :password_resets, only: [:new, :create, :edit, :update]

  root 'sessions#new'
end
