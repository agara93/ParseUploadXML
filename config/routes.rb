Rails.application.routes.draw do
  root      'tracks#index'        
  
  get 'new' => 'tracks#new'
    
  resources :tracks
end
