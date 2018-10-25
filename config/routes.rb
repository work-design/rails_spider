Rails.application.routes.draw do

  resources :locals
  resources :works do
    patch :run, on: :member
  end

end
