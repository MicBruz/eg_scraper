Rails.application.routes.draw do
  get 'scrapers/home'
  get 'scrapers/get_data'
  # get '/scrapers/get_data', to: 'scrapers#get_data'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
