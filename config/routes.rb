Rails.application.routes.draw do
  root to: 'boards#index'

    resources :boards, param: :uid do
      resources :columns, shallow: true do
        resources :cards
      end
    end
  end
  # resources :boards, only: [:show, :edit, :update, :destroy]
  # resources :columns, only: [:show, :edit, :update, :destroy]
  # resources :cards, only: [:show, :edit, :update, :destroy]
