Rails.application.routes.draw do
  
  resources :categories
  #resources :articles
  #resources :comments

  resources :articles do
      resources :comments, only: [:create, :destroy, :update, :show]
  end

  devise_for :users
  
  root 'welcome#index'

end
