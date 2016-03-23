Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


post '/users/visitCountry'
	post '/users/wishCountry'
	post '/users/register' => 'users#register'
	get '/users/registermenu' => 'users#registermenu'
	post '/users/login' => 'users#login'
	get '/users/logout' => 'users#logout'
	get '/users/logmenu' => 'users#logmenu'
  get '/users/showCountries' => 'users#showCountries'
 get '/country/change/:countryName' => 'country#change' , as: :countryName
 get '/users/showCountriesStart' => 'users#showCountriesStart' 
  get '/users/zoomCountry/:focus' => 'users#zoomCountry' , as: :focus
  get '/users/search' => 'users#search', as: :search_user

  post '/reviews/like' => 'reviews#like', as: :like_review
  
  resources :users do
    resources :messages
  end

  resources :country do
    resources :reviews do
      resources :comments
    end
  end

  root 'welcome#index'
 
  # Example of regular route:
  #   

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
