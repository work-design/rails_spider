Rails.application.routes.draw do


  scope :admin, module: 'spider/admin', as: :admin do
    resources :spider_works, shallow: true do
      get 'add_item/:item' => :add_item, on: :collection, as: :add_item
      get 'remove_item/:item' => :remove_item, on: :collection, as: :remove_item
      patch :run, on: :member
      resources :spider_caches
      resources :spider_resources
    end
  end

end
