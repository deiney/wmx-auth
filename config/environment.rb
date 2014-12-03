# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.server_settings = {
# 	address: "smtp.gmail.com",
# 	port: 25,
# 	domain: "wiimix.rocks",
# 	authentication: :login,
# 	user_name: "username",
# 	password: "password"
# }
