Rails.application.routes.draw do


  scope :admin, module: 'spider/admin', as: :admin do
    resources :locals
    resources :works do
      patch :run, on: :member
    end
  end

end
