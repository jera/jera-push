class JeraPush::MessagePresenter < BasePresenter

	def list_content
		JSON.pretty_generate({
			title: item.content["title"],
			body: item.content["body"]
		})
	end

	def display_content
		JSON.pretty_generate(item.content)
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