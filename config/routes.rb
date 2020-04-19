Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    delete :delete_file, on: :member
    resources :answers, shallow: true, only: [:new, :create, :update, :destroy] do
      patch :best, on: :member
    end
  end
end
