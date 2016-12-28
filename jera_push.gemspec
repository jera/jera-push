$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jera_push/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new 'jera_push', '1.0' do |s|
  s.name        = "jera_push"
  s.version     = JeraPush::VERSION
  s.authors     = ["Jera"]
  s.email       = ["hospedagem@jera.com.br"]
  s.homepage    = "https://bitbucket.org/jerasoftware/jera-push-gem"
  s.summary     = "Gem to use firebase push messages."
  s.description = "This gem is for send push messages via firebase and track their status."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.2', '>= 4.2.7'
  s.add_dependency 'enumerize', '~> 2.0'
  s.add_dependency 'httparty', '~> 0.14'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'kaminari', '~> 0.17'
  s.add_dependency 'responders', '~> 2.3'
  s.add_dependency 'jquery-rails', '~> 4.2'

  s.add_development_dependency 'sqlite3', '~> 1.3'
end
