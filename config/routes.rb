Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root "top#index"
  resources :userpages, only: %i[ index new create edit update show destroy ] do
      get :autocomplete, on: :collection
  end    
  get 'images/ogp.png', to: 'images#ogp', as: 'images_ogp'
  resources :positive_words, only: %i[index]

  post "ai_messages/generate", to: "ai_messages#generate", as: :ai_messages_generate
  resources :ai_messages, only: %i[ new create edit update show ]
  
  resources :word_favorites, only: %i[create destroy]

  resources :posts do
    resources :comments, only: %i[create edit update destroy], shallow: true
    collection do
      get :post_favorites, as: :favorites
      get :autocomplete
      get :favorites_autocomplete
    end
  end

  namespace :admin do
    resources :posts, only: [:index, :new, :create, :show, :edit, :update ,:destroy]
  end
  
  resources :post_favorites, only: %i[create destroy]
  
  resources :contacts, only: [:new, :create]
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
