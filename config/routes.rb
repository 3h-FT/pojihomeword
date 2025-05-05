Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "top#index"

  resources :userpages, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :positive_words, only: [:index]

  post "ai_messages/generate", to: "ai_messages#generate", as: :ai_messages_generate
  get "ai_messages/new", to: "ai_messages#new", as: :new_ai_message

  resources :word_favorites, only: [ :create, :destroy ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
