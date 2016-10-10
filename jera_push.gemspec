$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jera_push/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jera_push"
  s.version     = JeraPush::VERSION
  s.authors     = ["Jera"]
  s.email       = ["marcaoas@jera.com.br"]
  s.homepage    = "https://bitbucket.org/jerasoftware/jera-push-gem"
  s.summary     = "Gem to use firebase push messages."
  s.description = "This gem is for send push messages via firebase and track their status."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.2.6'
  s.add_dependency 'enumerize'
  s.add_dependency 'httparty'
  s.add_dependency 'sass-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'responders'
  s.add_dependency 'jquery-rails'

  s.add_development_dependency "sqlite3"
end
