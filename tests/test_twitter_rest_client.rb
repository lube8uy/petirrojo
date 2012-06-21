require File.expand_path(File.dirname(__FILE__) + '/edgecase')
require File.expand_path(File.dirname(__FILE__) + '/../twitter_rest_client.rb')

class TestTwitterRestClient < EdgeCase::Koan

	def test_is_object
		t = TwitterRestClient.new
		assert_equal true, t.is_a?(TwitterRestClient)
	end
	
	def test_get_twits_for_trends_ok
		#trend tiene espacios al principio y al final
		
		#trend correcto
		
		#trend tiene caracteres que deben ser encodeados
		
		#trend es numerico
		
  end
  
  def test_get_twits_for_trends_not_found
		#trend es vacio
		
		#trend tiene solo espacios
		
  end
  
  def test_get_twit_by_id_ok
		#el id tiene espacios
		
		#el id es numerico  130022282960715776
		
		#el id es string sin espacios  
  end
  
  def test_get_twit_by_id_not_found
		#id no numerico
		
		#id 0
		
		#id negativo 
		
		#id vacio 
  end
  
  def test_get_user_information_by_id_ok
		#el id tiene espacios
		
		#el id es numerico  783214
		
		#el id es string sin espacios    
  end
  
  def test_get_user_information_by_id_not_found
		#id no numerico
		
		#id 0
		
		#id negativo 
		
		#id vacio   
  end  
  
end