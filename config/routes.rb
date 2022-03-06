Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :users, only: %i[show create] do
      post :login, on: :collection

      resources :contacts do
      end
    end
  end
end
