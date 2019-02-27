Rails.application.routes.draw do
  root to: 'boards#new'

  # secret url for handle boards
  # these routes are excluded from routing, because this functionality is not in the technical task

  get 'secret/boards', to: 'boards#index'
  delete 'secret/boards', to: 'boards#destroy'

  resources :boards, except: [:index, :new, :destroy], param: :uid do
    resources :columns, shallow: true do
      resources :cards
    end
  end
end
