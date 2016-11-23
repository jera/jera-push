#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  config.firebase_api_key = "YOUR_API_KEY"
  config.resource_name = "<%= file_name.classify %>"

  # Resource attribute showed in views
  # config.resource_attributes = [:email, :name]

  # Topic default
  # You should put with your environment
  config.default_topic = 'jera_push_development'

  # Admin credentials
  # config.admin_login = {
  #   username: 'jera_push',
  #   password: 'JeraPushAdmin'
  # }

end
