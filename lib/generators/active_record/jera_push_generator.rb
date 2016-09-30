require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class JeraPushGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def create_devices_table
        migration_template "create_jera_push_devices.rb", "db/migrate/create_jera_push_devices.rb"
      end

      def create_messages_table
        migration_template "create_jera_push_messages.rb", "db/migrate/create_jera_push_messages.rb"
        migration_template "create_jera_push_messages_devices.rb", "db/migrate/create_jera_push_messages_devices.rb"
      end
    end
  end
end
