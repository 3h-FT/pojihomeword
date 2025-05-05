# Pin npm packages by running ./bin/importmap

pin "application"
pin "situations", to: "situations.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true

