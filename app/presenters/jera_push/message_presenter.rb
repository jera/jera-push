class JeraPush::MessagePresenter < BasePresenter

	def list_content
		"\{\n\t\"title\": #{item.content["title"]},\n\t\"body\": #{item.content["body"]}\n\}"
	end

	def display_created_at
		item.created_at.strftime('%d/%m/%Y %H:%M')
	end

	def show_link
		helpers.link_to(
			helpers.t('jera_push.admin.buttons.details'),
			Rails.application.routes.url_helpers.jera_push_admin_message_path(item), class: 'waves-effect waves-light btn'
		)
	end

end