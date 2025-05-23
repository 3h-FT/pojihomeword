# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

unless ENV["CI"]
  secret_path = Rails.root.join("tmp/local_secret.txt")
  File.binwrite(secret_path, "abc123") unless File.exist?(secret_path)
end
