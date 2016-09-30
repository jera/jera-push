Rails.application.routes.draw do
  namespace :jera_push do
    resources :devices, only: [:create, :delete]
  end
end
