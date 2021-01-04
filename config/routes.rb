Rails.application.routes.draw do
  root 'application#welcome'

  get '/genres/popular', to: 'genres#popular', as: 'popular_genres'
  get '/genres/:id/delete', to: 'genres#delete', as: 'delete_genre'
  delete '/genres/:id', to: 'genres#destroy', as: 'destroy_genre'
  resources :genres, except: [:destroy]

  get '/authors/popular', to: 'authors#popular', as: 'popular_authors'
  get '/authors/:id/delete', to: 'authors#delete', as: 'delete_author'
  delete '/authors/:id', to: 'authors#destroy', as: 'destroy_author'
  resources :authors, except: [:destroy]

  get 'books/popular', to: 'books#popular', as: 'popular_books'
  get '/books/:id/delete', to: 'books#delete', as: 'delete_book'
  delete '/books/:id', to: 'books#destroy', as: 'destroy_book'
  resources :books, except: [:destroy]

  get '/signup', to: 'users#new'
  resources :users, except: [:new] do
    resources :authors, only: [:index, :show, :new, :create]
    resources :books, only: [:index, :show, :new, :create]
    resources :genres, only: [:index, :show, :new, :create]
  end

  post '/users/:user_id/unfavorite/:class_/:id', to: 'users#unfavorite'
  post '/users/:user_id/favorite/:class_/:id', to: 'users#favorite'

  patch '/users/:user_id/favorite_authors/:id', to: 'favorite_authors#update', as: 'update_author_notes'
  patch '/users/:user_id/favorite_books/:id', to: 'favorite_books#update', as: 'update_book_notes'
  patch '/users/:user_id/favorite_genres/:id', to: 'favorite_genres#update', as: 'update_genre_notes'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create', as: 'do_login'
  get '/auth/:provider/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#logout'
  post '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
