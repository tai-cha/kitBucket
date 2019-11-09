Rails.application.routes.draw do
  get 'versions/show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :packages, only:[:index, :show, :new, :create], param: :package_id do
    resources :version
  end
end
