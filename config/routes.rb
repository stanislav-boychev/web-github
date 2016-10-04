Rails.application.routes.draw do
  resources :favourite_language, controller: 'favourite_language', param: 'username', path: 'favourite-language', only: [:show]

  get '/css-test', controller: 'css_test', action: :index
end
