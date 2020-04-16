Rails.application.routes.draw do
  resources :movies
  mount Grapes::API => '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
