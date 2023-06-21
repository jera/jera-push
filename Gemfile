source 'https://rubygems.org'

# Declare your gem's dependencies in jera_push.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem "faker"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

gem 'byebug', group: [:development, :test]

group :test do
  gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda', '~> 4.0'
  gem 'database_cleaner', '~> 2.0', '>= 2.0.1'
  gem 'rspec-rails', '~> 5.0', '>= 5.0.2'
end