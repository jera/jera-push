#this is the intilizer
#here you will set up the jera push configuration
JeraPush.setup do |config|
  # Change this for every new model
  config.resources_name = ["<%= file_name.classify %>"]
  # You need to create a Account Service on google cloud, with editor permission or administrator. Flow this doc: https://cloud.google.com/iam/docs/service-accounts-create?hl=pt-br
  config.project_id = "YOUR_PROJECT_ID" # inside of the account service json
  config.credentials_path = Rails.root.join("YOUR_CREDENTIALS_NAME").to_path #https://firebase.google.com/docs/cloud-messaging/migrate-v1?hl=pt-br#provide-credentials-manually
  ######################################################
  # Resource attribute showed in views                 #
  # IMPORTANT: All models need to have this attributes #
  # config.resource_attributes = [:email, :name]       #
  ######################################################

  # Topic default
  # You should put with your environment
  config.default_topic = 'jera_push_development'

  # Admin credentials
  # config.admin_login = {
  #   username: 'jera_push',
  #   password: 'JeraPushAdmin'
  # }

end
