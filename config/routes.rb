Rails.application.routes.draw do
  root 'scrapers#home'
  get 'scrapers/get_items'
  get 'filtered_by_sex/refresh_numbers'
  get 'numbers_filtered_by_sex/home'
  # get '/scrapers/get_data', to: 'scrapers#get_data'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
