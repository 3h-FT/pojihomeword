# Pin npm packages by running ./bin/importmap
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.js"
pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-autocomplete" # @3.1.0