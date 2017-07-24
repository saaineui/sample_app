Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'

  get 'signup' => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :users
  resources :bookmarks, only: %i[new destroy]
  resources :books do
    member do
      get 'upload'
      get 'galley', to: 'books#galley', as: :galley
      post 'print', to: 'books#print', as: :print
    end
  end

  get 'books/:id/:location', to: 'books#show', as: :open_book 

  post	'upload_review'	=>	'sections#new'
end
