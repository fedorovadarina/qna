Rails.application.routes.draw do
  concern :votable do
    post :vote_up, :vote_down, on: :member
  end

  concern :commentable do
    resources :comments, only: %i[create]
  end

  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true, concerns: %i[votable commentable] do
    resources :answers, only: %i[new create update destroy], concerns: %i[votable commentable] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :users, only: :show
end
