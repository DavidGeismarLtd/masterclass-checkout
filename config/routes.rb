Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "signup", to: "payment#create_stripe_customer"
  get 'checkout', to: 'payments#new'
  get 'payment_informations', to: 'payments#payment_informations'
  post 'checkout', to: 'payments#create'
  get '/payments/thank-you', to: 'payments#thank_you', as: :thank_you


  # Defines the root path route ("/")
  # root "posts#index"
end
