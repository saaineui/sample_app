Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'
  get    'help'    => 'static_pages#help'

  get    'signup'  => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :bookmarks, only: %i[new destroy]
  resources :books do
    resources :sections, only: %i[index create]
    
    member do
      get 'upload'
      get 'galley'
      post 'print'
      get 'illustrated'
      post 'i9d_print'
    end
  end

  get 'books/:id/:location', to: 'books#show', as: :open_book 
end
