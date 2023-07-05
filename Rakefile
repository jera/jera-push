require 'rake'

begin
  require 'bundler/setup'

  Bundler::GemHelper.install_tasks
rescue LoadError
  puts 'although not required, bundler is recommended for running the tests'
end

task default: :spec

require 'rspec/core/rake_task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'JeraPush'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-performance'
  task.requires << 'rubocop-rspec'
end
