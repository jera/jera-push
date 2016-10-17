require 'rails/generators/base'

module JeraPush
  class ViewsGenerator < Rails::Generators::Base
    desc "This generator copy the admin views for jera push"
    source_root File.expand_path("../../../../app/views/", __FILE__)

    def copy_views
      copy_file message_view_path('_message_attributes.html.erb'), "app/views/#{message_view_path('_message_attributes.html.erb')}"
      copy_file message_view_path('_message_device.html.erb'), "app/views/#{message_view_path('_message_device.html.erb')}"
      copy_file message_view_path('_news.html.erb'), "app/views/#{message_view_path('_news.html.erb')}"
      copy_file message_view_path('create.js.erb'), "app/views/#{message_view_path('create.js.erb')}"
      copy_file message_view_path('device_filter.js.erb'), "app/views/#{message_view_path('device_filter.js.erb')}"
      copy_file message_view_path('index.html.erb'), "app/views/#{message_view_path('index.html.erb')}"
      copy_file message_view_path('message_devices_filter.js.erb'), "app/views/#{message_view_path('message_devices_filter.js.erb')}"
      copy_file message_view_path('new.html.erb'), "app/views/#{message_view_path('new.html.erb')}"
      copy_file message_view_path('show.html.erb'), "app/views/#{message_view_path('show.html.erb')}"
    end

    def copy_layout
      copy_file 'layouts/jera_push/jera_push.html.erb', 'app/views/layouts/jera_push/jera_push.html.erb'
      copy_file 'layouts/jera_push/navbar.html.erb', 'app/views/layouts/jera_push/navbar.html.erb'
    end

    def copy_kaminari
      kaminari_path = 'kaminari'
      copy_file "#{kaminari_path}/_gap.html.erb", "app/views/#{kaminari_path}/_gap.html.erb"
      copy_file "#{kaminari_path}/_next_page.html.erb", "app/views/#{kaminari_path}/_next_page.html.erb"
      copy_file "#{kaminari_path}/_page.html.erb", "app/views/#{kaminari_path}/_page.html.erb"
      copy_file "#{kaminari_path}/_paginator.html.erb", "app/views/#{kaminari_path}/_paginator.html.erb"
      copy_file "#{kaminari_path}/_prev_page.html.erb", "app/views/#{kaminari_path}/_prev_page.html.erb"
    end


    protected

      def admin_path
        "jera_push/admin/"
      end

      def message_view_path file_name
        "#{admin_path}/device/#{file_name}"
      end

      def device_view_path file_name
        "#{admin_path}/device/#{file_name}"
      end
  end
end
