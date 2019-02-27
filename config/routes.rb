Rails.application.routes.draw do
  root to: 'boards#new'

  # secret url for handle boards
  # these routes are excluded from routing, because this functionality is not in the technical task


  resources :boards, except: [:index, :new, :destroy], param: :uid do
    resources :columns, shallow: true do
      resources :cards
    end
  end

  delete 'boards/:uid', to: 'boards#destroy'
  
  scope '/secret' do
    get 'boards', to: 'boards#index'
  end
end
