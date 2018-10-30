Rails.application.routes.draw do


  scope :admin, module: 'spider/admin', as: :admin do
    resources :spider_works, shallow: true do
      patch :run, on: :member
      resources :spider_caches
      resources :spider_resources
    end
  end

end
