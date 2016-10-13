class JeraPushGenerator < Rails::Generators::NamedBase
  desc "This generator creates an initializer file at config/initializers"
  source_root File.expand_path("../templates", __FILE__)

  MissingModel = Class.new(Thor::Error)

  def initializer_file
    template 'jera_push.rb', 'config/initializers/jera_push.rb'
  end

  def locale_file
    copy_file '../../../../config/locale/jera_push.pt-BR.yml', 'config/locales/jera_push.pt-BR.yml'
  end

  def generate_migrations
		unless model_exists?
			raise MissingModel,
				"\n\tModel \"#{file_name.titlecase}\" doesn't exists. Please, create your Model and try again."
		end

		inject_into_file model_path, "\n\thas_many :devices, foreign_key: :resource_id, class_name: 'JeraPush::Device'", after: ' < ActiveRecord::Base'

    case self.behavior
    when :invoke
      generate "active_record:jera_push", file_name
    when :revoke
      Rails::Generators.invoke "active_record:jera_push", [file_name], behavior: :revoke
    end
  end

  private

  	def model_exists?
  		File.exist?(File.join(destination_root, model_path))
  	end

	  def model_path
		  @model_path ||= File.join("app", "models", "#{file_path}.rb")
		end
end
