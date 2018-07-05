#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  config.firebase_api_key = "YOUR_API_KEY"
  # Change this for every new model
  config.resource_name = ["<%= file_name.classify %>"]

  # Resource attribute showed in views
  # IMPORTANT: All models need to have this attributes
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
