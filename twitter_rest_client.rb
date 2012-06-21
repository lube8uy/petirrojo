require 'net/http'
require 'json'

class TwitterRestClient

	def get_trends
		return get('http://api.twitter.com/1/trends/daily.json')
	end
	
	def get_twits_for_trend(trend)
		return get('http://search.twitter.com/search.json', {'q' => trend.strip})
	end
	
	def get_twit_by_id(id)
		return get("http://api.twitter.com/1/statuses/show/#{id.to_s.strip}.json")
	end
	
	def get_user_information_by_id(id)
		return get('http://api.twitter.com/1/users/lookup.json', {'user_id' => id})
	end
	
	##
	# Tries to get information from a given url and parameters. 
	# If the response is successful it returns an array/hash representation of the data
	# otherwise a TwitterRestClientException is raised
	##
	def get(uri, params={})
		uri = URI(uri)
		uri.query = URI.encode_www_form(params)
		p uri
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
# Represents a server response different to 200
##
class TwitterRestClientException < StandardError

	attr :code
	
  def initialize(code)
    @code = code
  end
  
  def not_found?
  	return @code == 404
  end
  
  def server_error?
  	return !@code.to_s[/\A5/].nil?
  end
  
end

##
# Error thrown when the value of a parameter used in a uri is invalid
##
class TwitterRestClientArgumentException < StandardError

end
