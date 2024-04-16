$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jera_push/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new 'jera_push', '2.0' do |spec|
  spec.name                  = "jera_push"
  spec.version               = JeraPush::VERSION
  spec.required_ruby_version = '>= 3.0.3'
  spec.authors               = ["Jera"]
  spec.email                 = ["hospedagem@jera.com.br"]
  spec.homepage              = "https://github.com/jera/jera-push"
  spec.summary               = "Gem to use firebase push messages."
  spec.description           = "This gem is for send push messages via firebase and track their status."
  spec.license               = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.test_files = Dir["test/**/*"]

  spec.add_dependency 'rails', '>= 7.1'
  spec.add_dependency 'enumerize', '>= 2.4'
  spec.add_dependency 'httparty', '>= 0.21'
  spec.add_dependency 'sass-rails', '>= 6.0'
  spec.add_dependency 'kaminari', '>= 1.2.2'
  spec.add_dependency 'responders', '>= 3.1'
  spec.add_dependency 'jquery-rails', '>= 4.5.1'
  spec.add_dependency 'google-apis-fcm_v1', '>= 0.19.0', '< 1.0'

  spec.add_development_dependency 'rake', '~> 13.0.6'
  spec.add_development_dependency 'sqlite3'
end
