Rails.application.routes.draw do
  # Otras rutas...

  resources :movies

  # La ruta principal se coloca al final
  root 'movies#index'
end
