require 'knock'

Knock.configure do |config|
  config.key = ENV['KNOCK_API_KEY']
  config.timeout = 120
end
