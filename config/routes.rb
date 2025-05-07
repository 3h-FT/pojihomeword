Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "top#index"

  resources :userpages, only: %i[ index new create edit update destroy ]
  resources :positive_words, only: %i[index]

  post "ai_messages/generate", to: "ai_messages#generate", as: :ai_messages_generate
  get "ai_messages/new", to: "ai_messages#new", as: :new_ai_message

  resources :word_favorites, only: %i[create destroy]

  resources :posts, only: %i[ index new create show edit update destroy ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
