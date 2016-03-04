Rails.application.routes.draw do
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  # Accounts & Sessions
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :job_applications do
    resources :notes, except: :index
  end
  resources :contacts do
    resources :notes, except: :index
  end
  resources :notes,     only: :index
  resources :companies, only: [:index, :show, :new, :create]
  resources :cover_letters
  resources :postings
  resources :users,     except: :index

  root 'home#index'
end
