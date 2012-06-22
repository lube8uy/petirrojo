require File.expand_path(File.dirname(__FILE__) + '/edgecase')
require File.expand_path(File.dirname(__FILE__) + '/../twitter_rest_client.rb')

class TestTwitterRestClient < EdgeCase::Koan

	def test_is_object
		t = TwitterRestClient.new
		assert_equal true, t.is_a?(TwitterRestClient)
	end
	
	def test_get_trends_ok
		t = TwitterRestClient.new
		
		#retorna una respuesta
		response = t.get_trends()
		assert response != nil
	end
	
	def test_get_twits_for_trends_ok
		t = TwitterRestClient.new
		
		#trend tiene espacios al principio y al final
		response_space = t.get_twits_for_trend("   centeno   ")
		assert response_space != nil
		
		#trend correcto
		response = t.get_twits_for_trend("centeno")
		assert response != nil
		
		#la respuesta de trend correcto coincide con la que tiene espacios
		assert_equal response_space["results"], response["results"]
		
		#trend tiene caracteres que deben ser encodeados
		response_encode = t.get_twits_for_trend("#uruguay")
		assert response_encode != nil
		
		#trend es numerico
		response_encode = t.get_twits_for_trend(123)	
		assert response_encode != nil	
  end
  
  def test_get_twits_for_trends_not_found
  	t = TwitterRestClient.new
  
		#trend es vacio		
		assert_raise(TwitterRestClientArgumentException) do
      response = t.get_twits_for_trend("")
    end
		
		#trend es nil
		assert_raise(TwitterRestClientArgumentException) do
      response = t.get_twits_for_trend(nil)
    end
			
		#trend tiene solo espacios
		assert_raise(TwitterRestClientArgumentException) do
      response = t.get_twits_for_trend("   ")
    end			
  end
  
  def test_get_twit_by_id_ok
  	t = TwitterRestClient.new
  	  
		#el id tiene espacios
		response_space = t.get_twit_by_id("   130022282960715776  ")
		assert response_space != nil	
		
		#el id es numerico  130022282960715776
		response_numeric = t.get_twit_by_id(130022282960715776)
		assert response_numeric != nil	
		
		#el id es string sin espacios  
		response_string = t.get_twit_by_id("130022282960715776")
		assert response_string != nil	
		
		#las 3 respuestas coinciden
		assert_equal response_space["results"], response_numeric["results"]
		assert_equal response_space["results"], response_string["results"]
  end
  
  def test_get_twit_by_id_not_found
  	t = TwitterRestClient.new
  	
		#id no numerico
		assert_raise(TwitterRestClientArgumentException) do
			t.get_twit_by_id("sab")
		end
		
		#id 0
		assert_raise(TwitterRestClientArgumentException) do
			t.get_twit_by_id(0)
		end

		#id nil
		assert_raise(TwitterRestClientArgumentException) do
			t.get_twit_by_id(nil)
		end
		
		#id negativo 
		assert_raise(TwitterRestClientArgumentException) do
			t.get_twit_by_id(-3)
		end
		
		#id vacio
		assert_raise(TwitterRestClientArgumentException) do
			t.get_twit_by_id("") 
		end
				
		#id no existe
		assert_raise(TwitterRestClientException) do
			t.get_twit_by_id(1)
		end
		
		#para el id que no existe la respuesta del error es "not_found"
		begin
			t.get_twit_by_id(1)
			assert false
		rescue TwitterRestClientException => ex
			assert_equal true, ex.not_found?
		end
  end
  
  def test_get_user_information_by_id_ok
  	t = TwitterRestClient.new
  	  	
		#el id tiene espacios
		response_space = t.get_user_information_by_id("   783214 ")
		assert response_space != nil
		assert response_space.size == 1
		
		#el id es numerico  783214
		response_numeric = t.get_user_information_by_id(783214)
		assert response_numeric != nil
		assert response_numeric.size == 1
		
		#el id es string sin espacios    
		response_string = t.get_user_information_by_id("783214")
		assert response_string != nil
		assert response_string.size == 1
		
		#las 3 respuestas coinciden
		assert_equal response_space[0]["id"], response_numeric[0]["id"]
		assert_equal response_space[0]["id"], response_string[0]["id"]
  end
  
  def test_get_user_information_by_id_not_found
  	t = TwitterRestClient.new
  	  	
		#id no numerico
		assert_raise(TwitterRestClientArgumentException) do
			t.get_user_information_by_id("ddd")
		end
		
		#id 0
		assert_raise(TwitterRestClientArgumentException) do
			t.get_user_information_by_id(0)
		end
		
		#id negativo 
		assert_raise(TwitterRestClientArgumentException) do
			t.get_user_information_by_id(-90)
		end
		
		#id nil 
		assert_raise(TwitterRestClientArgumentException) do
			t.get_user_information_by_id(nil) 
		end
		
		#id vacio 
		assert_raise(TwitterRestClientArgumentException) do
			t.get_user_information_by_id("")
		end
		
		#id no existe
		assert_raise(TwitterRestClientException) do
			t.get_user_information_by_id(1)
		end
		
		#para el id que no existe la respuesta del error es "not_found"
		begin
			t.get_user_information_by_id(1)
			assert false
		rescue TwitterRestClientException => ex
			assert_equal true, ex.not_found?
		end
  		
  end  
  
end
