Rails.application.routes.draw do
  # Accounts & Sessions
  get    'signup' => 'users#new'
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :job_applications
  resources :companies
  resources :interactions
  resources :cover_letters
  resources :postings
  resources :contacts

  # Search Suggestions
  match '/search_suggestions',
    to: 'search_suggestions#index',
    via: :get

  root 'home#index'
end
