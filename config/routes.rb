Rails.application.routes.draw do
  post 'users', to: 'users#create'
  get 'users', to: 'users#index'
	post 'messages', to: 'messages#create'
	get 'messages/:current_user_id/:target_user_id', to: 'messages#index'
end
