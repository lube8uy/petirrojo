require_relative 'edgecase'
require_relative '../twitter_formatter.rb'

class TestTwitterRestClient < EdgeCase::Koan
	
	def test_format_link
		#link con query string
		text = "http://ejemplo.com?q=hola@&b=80"
		assert_equal TwitterFormatter.linkify(text), "<a href='#{text}'>#{text}</a>"
		
		#link con anchor
		text = "http://ejemplo.com#aqui"
		assert_equal TwitterFormatter.linkify(text), "<a href='#{text}'>#{text}</a>"
		
		#link con anchor y espacios
		link = "http://ejemplo.com#aqui"
		text = "#{link} sigue el texto"
		assert_equal TwitterFormatter.linkify(text), "<a href='#{link}'>#{link}</a> sigue el texto"
		
		#no link
		text = "ejemplo.com?q=hola&b=80#si"
		assert_equal TwitterFormatter.linkify(text), text
		
		#con espacios
		link = "http://ejemplo.com?q=hola&b=80"
		text = "Entrar en \n#{link} y seguir"
		assert_equal TwitterFormatter.linkify(text), "Entrar en \n<a href='#{link}'>#{link}</a> y seguir"
		
		#seguido de un simbolo que no pertenece a url
		link = "http://ejemplo.com?q=hola"
		text = "Entrar en #{link}>>b=80 y seguir"
		assert_equal TwitterFormatter.linkify(text), "Entrar en <a href='#{link}'>#{link}</a>>>b=80 y seguir" 		
	end
	
	def test_free
		text = "Este texto no tiene nada para linkificar"
		assert_equal TwitterFormatter.linkify(text), text
	end
	
	def test_format_trend	
		#solo
		text = "#test  "
		assert_equal TwitterFormatter.linkify(text), "<a href='http://search.twitter.com/search.json?q=%23test'>#test</a>  "
		
		#rodeado de espacios
		text = "Esto es un twit #test!!>@009 para pruebas"
		assert_equal TwitterFormatter.linkify(text), "Esto es un twit <a href='http://search.twitter.com/search.json?q=%23test%21%21%3E%40009'>#test!!>@009</a> para pruebas"
		
		#rodeado de espacios - 2
		text = "Esto es un twit   #test!!>@009 para pruebas"
		assert_equal TwitterFormatter.linkify(text), "Esto es un twit   <a href='http://search.twitter.com/search.json?q=%23test%21%21%3E%40009'>#test!!>@009</a> para pruebas"
		
		#rodeado de espacios - 3
		text = "Esto es un twit #test\n para pruebas"
		assert_equal TwitterFormatter.linkify(text), "Esto es un twit <a href='http://search.twitter.com/search.json?q=%23test'>#test</a>\n para pruebas"
	end
	
	def test_combined
		#url con anchor y trend por separado
		link = "http://ejemplo.com#aqui"
		text = "Este link #{link} refiere al trend #test  " 
		assert_equal TwitterFormatter.linkify(text), "Este link <a href='#{link}'>#{link}</a> refiere al trend <a href='http://search.twitter.com/search.json?q=%23test'>#test</a>  "
		
		#varios links y trends
		text = "Tenemos primero un link #{link} seguido de un #trend y luego el mismo #{link} seguido de otro #magnificotrend"
		assert_equal TwitterFormatter.linkify(text), "Tenemos primero un link <a href='#{link}'>#{link}</a> seguido de un <a href='http://search.twitter.com/search.json?q=%23trend'>#trend</a> y luego el mismo <a href='#{link}'>#{link}</a> seguido de otro <a href='http://search.twitter.com/search.json?q=%23magnificotrend'>#magnificotrend</a>"
	end
	
end
