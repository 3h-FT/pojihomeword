Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "top#index"

  resources :userpages, only: %i[ index new create edit update destroy ]
  resources :positive_words, only: %i[index]

  post "ai_messages/generate", to: "ai_messages#generate", as: :ai_messages_generate
  resources :ai_messages, only: %i[ new create edit update ]

  resources :word_favorites, only: %i[create destroy]

  resources :posts do
    resources :comments, only: %i[create edit update destroy], shallow: true
    collection do
      get :post_favorites, as: :favorites
    end
  end
  resources :post_favorites, only: %i[create destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
