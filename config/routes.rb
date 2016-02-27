Rails.application.routes.draw do
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  # Accounts & Sessions
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :job_applications do
    resources :notes
  end
  resources :contacts do
    resources :notes
  end
  resources :companies
  resources :cover_letters
  resources :postings

  root 'home#index'
end
