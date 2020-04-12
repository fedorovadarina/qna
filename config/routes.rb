Rails.application.routes.draw do
  devise_for :users
  
  resources :questions, shallow: true, except: [:edit, :update] do
    resources :answers, only: [:new, :create, :destroy]
  end

  root to: 'questions#index'
end
