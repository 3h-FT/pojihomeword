# Pin npm packages by running ./bin/importmap

pin "application"
pin "situations", to: "situations.js"
pin "ai_messages", to: "ai_messages.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
