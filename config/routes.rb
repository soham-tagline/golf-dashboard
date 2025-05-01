Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root 'overviews#analytics'

  get 'overview/analytics', to: 'overviews#analytics'
  get 'course/analytics', to: 'courses#analytics'
  get 'booking_system/analytics', to: 'booking_systems#analytics'
end
