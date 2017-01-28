Rails.application.routes.draw do
  root to: 'visitors#index'
  get '/about', to: 'visitors#about', as: :about
end
