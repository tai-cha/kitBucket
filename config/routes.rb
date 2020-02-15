Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :apps, only: [:index, :show]
    end
  end

  resources :apps, only:[:index, :show, :new, :create], param: :app_id do
    resources :versions, only:[:show, :destroy], param: :name, constraints: {name: /[^\/]+/ } do
      get :define
    end
  end

  root 'home#index'

  get '*path', to: 'application#render_404'
end
