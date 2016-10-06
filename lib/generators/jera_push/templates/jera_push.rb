#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  config.firebase_api_key = "YOUR_API_KEY"
  config.resource_name = "<%= file_name.classify %>"

  # Resource attribute showed in views
  # config.resource_attributes = [:email, :name]
end
