Rails.application.routes.draw do
  namespace :jera_push do
    namespace :admin do
      resources :messages, only: [:index, :show]
      resources :devices, only: [:index] do
        collection do
          get :search
        end
      end
    end

    namespace :v1 do
      resources :devices, only: [:create] do
        collection do
          delete :destroy
        end
      end
    end
  end
end
