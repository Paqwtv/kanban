Rails.application.routes.draw do
  root to: 'boards#new'

  # secret url for handle boards
  # these routes are excluded from routing, because this functionality is not in the technical task

  scope '/secret' do
    resources :boards, only: [:index, :destroy], param: :uid
  end

  resources :boards, except: [:index, :new, :destroy], param: :uid do
    resources :columns, shallow: true do
      resources :cards
    end
  end
end
