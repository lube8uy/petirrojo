require 'net/http'
#http://ruby-doc.org/stdlib-1.9.3/libdoc/net/http/rdoc/Net/HTTP.html

class TwitterRestClient

	def get_trends
		get('https://api.twitter.com/1/trends/daily.json')
		#Cambiar por https
		#http://api.twitter.com/1/trends/daily.json
	end
	
	def get_twits_for_trend(trend)
		trend.strip
		#http://search.twitter.com/search.json?q=#honestyhour
	end
	
	def get_twit_by_id(id)
		#https://api.twitter.com/1/statuses/show/130022282960715776.json
	end
	
	def get_user_information_by_id(id)
		#Doc> https://dev.twitter.com/docs/api/1/get/users/lookup
		#Doc> https://dev.twitter.com/docs/api/1/get/users/profile_image/%3Ascreen_name
		# https://api.twitter.com/1/users/lookup.json?user_id=444
		# https://api.twitter.com/1/users/profile_image?screen_name=twitterapi&size=bigger 
	end
	
	def get(uri, params={})
		uri = URI(uri)
		uri.query = URI.encode_www_form(params)
		res = Net::HTTP.get_response(uri)
		puts res.body if res.is_a?(Net::HTTPSuccess)
	end
	
end

t = TwitterRestClient.new
t.get_trends
