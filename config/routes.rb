Rails.application.routes.draw do

  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  get '/sign_up', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :users, only: %i[show create], param: :screen_name do
    resources :apps, only: %i[index]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :apps, only: %i[index show new create], param: :app_id do
    resources :versions, only: %i[show destroy], param: :name, constraints: {name: /[^\/]+/ } do
      get :define
    end
  end

  root 'home#index'

  get '*path', to: 'application#render_404'
end
