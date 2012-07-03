require_relative 'twitter_controller.rb'
require_relative 'twitter_formatter.rb'

class TwitterView
	:controller
	
	attr :error
	attr :trend_list
	attr :current_trend_twits
	
	def initialize
		@controller = TwitterController.new
	end
	
	def has_error?
		return @error != nil
	end
	
	def reset_error
		@error = nil
	end
	
	def get_trends
		text = ""
		request = @controller.get_trends
		if request.is_success?
			trends = request.response
			trends["trends"].each do |hour, hour_trends|
				text += "Top 20 de trends para la fecha #{hour} \n"
				i = 1
				@trend_list = hour_trends
				hour_trends.each do |t|
					text += "#{i}.  " + t["name"] + "\n"
					i += 1
				end
				break #solo los de una hora
			end 
			reset_error 
		else
			@error = true
			text = request.error_message
		end
		return text
	end
	
	def drill_down_trend(number)
		number = number.to_i
		if number > 0 and number <= @trend_list.size
			return get_twits_for_trend(@trend_list[number-1]["name"])
		else
			fail
		end
	end
	
	def get_twits_for_trend(trend)
		text = ""
		request = @controller.get_twits_for_trend(trend)
		i = 1
		if request.is_success?
			@current_trend_twits = request.response["results"]
			@current_trend_twits.each do |twit|
				text += "#{i}. El #{twit['created_at']} #{twit['from_user']} dijo: \n"
				text += TwitterFormatter.linkify(twit['text'])
				text += "\n\n"
				i += 1
			end
			reset_error
		else
		p "hola" + request.error_message
			@error = true
			text += request.error_message
		end
		return text
	end
	
	def drill_down_user(number)
		number = number.to_i
		if number > 0 and number <= @current_trend_twits.size
			return get_user_information_by_id(@current_trend_twits[number-1]["from_user_id"])
		else
			fail
		end 
	end

	def get_user_information_by_id(id)
		text = ""
		request = @controller.get_user_information_by_id(id)
		if request.is_success?
			user = request.response[0]		
			text += "Nombre de usuario: #{user['screen_name']}\n"
			text += "Nombre: #{user['name']}\n"
			text += "Descripcion: " + TwitterFormatter.linkify(user['description']) + "\n"
			text += "Imagen: #{user['profile_image_url']}\n"
			reset_error
		else
			@error = true
			text += request.error_message
		end
		return text
	end
end
