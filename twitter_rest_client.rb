require 'net/http'
require 'json'

class TwitterRestClient

	def get_trends
		return get('http://api.twitter.com/1/trends/daily.json')
	end
	
	def get_twits_for_trend(trend)
		check_string_argument(trend)
		return get('http://search.twitter.com/search.json', {'q' => trend.to_s.strip})
	end
	
	def get_twit_by_id(id)
		check_id_argument(id)
		return get("http://api.twitter.com/1/statuses/show/#{id.to_s.strip}.json")
	end
	
	def get_user_information_by_id(id)
		check_id_argument(id)
		return get('http://api.twitter.com/1/users/lookup.json', {'user_id' => id.to_s.strip})
	end
	
	def check_id_argument(id)
		id = id.to_s.strip
		#En una situacion real el mensaje de error no se escribe aqui :P
		raise TwitterRestClientArgumentException, "Un id debe ser numerico y mayor a 0" if id.to_s[/^[1-9]+[0-9]*$/].nil?
	end
	
	def check_string_argument(value)
		raise TwitterRestClientArgumentException, "La palabra elegida no debe ser vacia" if value.to_s.strip == ""
	end
		
	##
	# Intenta obtener informacion de una url dada y sus parametros
	# Si la respuesta es satisfactoria retorna una respuesta en forma de array o hash
	# sino lanza una excepcion TwitterRestClientException
	##
	def get(uri, params={})
		uri = URI(uri)
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
		if res.is_a?(Net::HTTPSuccess)
			response = res.body
			return JSON.parse(response)
		else 
			raise TwitterRestClientException.new(res.code), "#{res.code}: #{res.message}"
		end
	end	
	
end

##
# Representa una respuesta de servidor diferente a 200
##
class TwitterRestClientException < StandardError

	attr :code
	
  def initialize(code)
    @code = code
  end
  
  def not_found?
  	return @code == "404"
  end
  
  def server_error?
  	return !@code.to_s[/\A5/].nil?
  end
  
end

##
# Se lanza este error cuando los parametros que se van a usar para
# hacer la peticion a twitter son invalidos
##
class TwitterRestClientArgumentException < StandardError

end
