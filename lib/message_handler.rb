module MessageHandler

	def check_if_direct_message
		if params[:micropost][:content][0..1] == "d "
			save_micropost_as_direct_message
		end
	end

	def save_micropost_as_direct_message
		text           = params[:micropost][:content]
		recipient      = get_direct_message_recipient(text)
		content        = trim_micropost_content(text)
		direct_message = DirectMessage.create(sender_id: current_user.id, recipient_id: recipient.id, content: content)
		if direct_message.save 
			redirect_to :back, 
				flash: { success: "DirectMessage sent to #{recipient.user_name}."}
		else
			redirect_to :back, 
				flash: { error: "An error has occured, your DirectMessage was not sent." }
		end
	end

	private 

		def get_direct_message_recipient(text)
			target_username = text.slice(/\Ad\s\b(\w|-|\.)+/i)[2..-1]
			User.find_by(user_name: target_username)
		end

		def trim_micropost_content(text)
			# strip off 'd username '
			text.tap { |s| s.slice!(/\Ad\s\b(\w|-|\.)+/i) }
		end
end