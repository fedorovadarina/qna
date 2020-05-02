Rails.application.routes.draw do
  concern :votable do
    post :vote_up, :vote_down, on: :member
  end

  devise_for :users
  root to: 'questions#index'

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: [:new, :create, :update, :destroy], concerns: :votable do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :users, only: :show
end
