Rails.application.routes.draw do
  namespace :jera_push do
    namespace :v1 do
      resources :devices, only: [:create] do
        collection do
          delete :destroy, path: '/'
        end
      end
    end
  end
end
