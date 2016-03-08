Rails.application.routes.draw do
  match '/search_suggestions', to: 'search_suggestions#index', via: :get

  # Sessions
  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # User accounts, profiles
  resource :profile, controller: 'users', as: 'user'

  resources :notes,         only: :index
  resources :cover_letters, only: :index, controller: 'job_applications/cover_letters'
  resources :postings,      only: :index, controller: 'job_applications/postings'
  resources :companies,     only: [:index, :show, :new, :create]
  resources :categories,    only: [:index, :show]

  resources :job_applications do
    resources :notes,         except: :index
    resource  :cover_letter,  controller: 'job_applications/cover_letters'
    resource  :posting,       controller: 'job_applications/postings'
  end

  resources :contacts do
    resources :notes, except: :index
  end

  root 'home#index'
end
