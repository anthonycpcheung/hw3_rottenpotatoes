Rottenpotatoes::Application.routes.draw do
  resources :movies do
    member do
      get 'similar_movies'
    end
  end

  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')

  #match "/:controller/:action/:field"
end
