##
# Controlador de operaciones sobre twitter
##

require_relative 'twitter_rest_client.rb'

class TwitterController

	def get_trends
		ask_rest_client(__method__)
	end
	
	def get_twits_for_trend(trend)	
		ask_rest_client(__method__, trend)
	end
	
	def get_twit_by_id(id)
		ask_rest_client(__method__, id)		
	end
	
	def get_user_information_by_id(id)
		ask_rest_client(__method__, id)
	end
	
	private
	
	def ask_rest_client(method, *params)
		begin
			t = TwitterRestClient.new
			result = t.send(method, *params)
			response = TwitterControllerResponse.new(result)
		rescue Exception => ex
			response = TwitterControllerResponse.new(nil, ex)
		end	
	end
		
end

class TwitterControllerResponse

	attr_reader :response
	attr_reader :ex
	attr_reader :error_message

	def initialize(response, ex = nil)
		@response = response
		@ex = ex     
		set_error_message
	end

	def is_success?
		@ex.nil?
	end

	private

	def set_error_message
		#En una situacion real los mensajes de respuesta serian tags a traducir en la vista
		if @ex.is_a?(TwitterRestClientException)
			if @ex.not_found?
				@response = "No existen resultados para tu busqueda" 
			elsif @ex.server_error?
				@response = "Twitter no puede responder tu consulta en estos momentos"
			else
				@response = @ex.message
			end
		elsif !is_success?
			@response = ex.message
		end
	end
	
end
