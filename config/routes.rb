Rails.application.routes.draw do
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  # Accounts & Sessions
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :notes,         only: :index
  resources :cover_letters, only: :index
  resources :postings,      only: :index
  resources :job_applications do
    resources :notes,         except: :index
    resource  :cover_letter
    resource  :posting
  end
  resources :contacts do
    resources :notes, except: :index
  end
  resources :companies, only: [:index, :show, :new, :create]
  resources :users,     except: :index

  root 'home#index'
end
