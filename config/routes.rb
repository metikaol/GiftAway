Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: {format: :json} do
  namespace :v1 do
    resources :posts
    resources :tokens, only: [:create]
  end
end


  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :posts  do
  resources :answers, only: [:create, :destroy], shallow: true
end

get('/', {to: 'posts#index'})

post('/posts', {to: 'posts#create', as: 'create_post'})
end
