class JeraPushGenerator < Rails::Generators::NamedBase
  desc "This generator creates an initializer file at config/initializers"
  source_root File.expand_path("../templates", __FILE__)

  MissingModel = Class.new(Thor::Error)

  def copy_initializer_file
    template "jera_push.rb", 'config/initializers/jera_push.rb'
  end

  def generate_migrations
		unless model_exists?
			raise MissingModel,
				"\n\tModel \"#{file_name.titlecase}\" doesn't exists. Please, create your Model and try again."
		end

		inject_into_file model_path, "\n\thas_many :devices, class_name: 'JeraPush::Device'", after: ' < ActiveRecord::Base'

    generate "active_record:jera_push", file_name
  end

  private

  	def model_exists?
  		File.exist?(File.join(destination_root, model_path))
  	end

	  def model_path
		  @model_path ||= File.join("app", "models", "#{file_path}.rb")
		end
end
