devise_for :users
devise_for :admins

root "pages#home"
resources :products,            only: [:create]

%w( 404 422 500 ).each do |code|
  get code, :to => "errors#show", :code => code
end

namespace :user do
  root "products#index"
  resources :products, only: [:show]
  resources :charges, only: [:new, :create] do
    get "success", to: "charges#success"
    get "cancel", to: "charges#cancel"
  end

  resources :subscriptions, only: [:new, :create] do
    get "success", to: "subscriptions#success"
    get "cancel", to: "subscriptions#cancel"
    post "manage", to: "subscriptions#manage"
    get "manage-return", to: "subscriptions#manage_return"
  end
  resources :unsubscriptions, only: [:create]
end

namespace :admin do
…
end