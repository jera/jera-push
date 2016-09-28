class JeraPushGenerator < Rails::Generators::Base
  desc "This generator creates an initializer file at config/initializers"
  source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    copy_file "jera_push.rb", "config/initializers/jera_push.rb"
  end
end
