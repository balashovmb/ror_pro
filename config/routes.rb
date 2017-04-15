Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      delete 'cancel_vote'
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      patch 'set_best', on: :member
    end
    resources :comments, only: [:new,:create], defaults: { commentable: 'question' }    
  end

  resources :answers, only: [] do
    resources :comments, only: [:new,:create], defaults: { commentable: 'answer' }
  end

  resources :comments, only: :destroy
  
  resources :attachments, only: :destroy  

  root 'questions#index'

  mount ActionCable.server => '/cable'  
end
