require_relative 'edgecase'
require_relative '../twitter_controller.rb'

class TestTwitterController < EdgeCase::Koan

	def test_is_object
		t = TwitterController.new
		assert_equal true, t.is_a?(TwitterController)
	end
	
	def test_get_trends_ok
		t = TwitterController.new
		
		#retorna una respuesta
		r = t.get_trends()
		assert r != nil
	end
	
	def test_get_twits_for_trends_ok
		t = TwitterController.new
		
		#trend tiene espacios al principio y al final
		r_space = t.get_twits_for_trend("   centeno   ")
		assert r_space != nil
		
		#trend correcto
		r = t.get_twits_for_trend("centeno")
		assert r != nil
		
		#la respuesta de trend correcto coincide con la que tiene espacios
		assert_equal r_space.response["results"], r.response["results"]
		
		#trend tiene caracteres que deben ser encodeados
		r_encode = t.get_twits_for_trend("#uruguay")
		assert r_encode != nil
		
		#trend es numerico
		r_encode = t.get_twits_for_trend(123)	
		assert r_encode != nil	
  end
  
  def test_get_twits_for_trends_not_found
  	t = TwitterController.new
  
		#trend es vacio		
		assert_equal t.get_twits_for_trend("").is_success?, false 
		
		#trend es nil
		assert_equal t.get_twits_for_trend(nil).is_success?, false 
			
		#trend tiene solo espacios
		assert_equal t.get_twits_for_trend("   ").is_success?, false 
  end
  
  def test_get_twit_by_id_ok
  	t = TwitterController.new
  	  
		#el id tiene espacios
		r_space = t.get_twit_by_id("   130022282960715776  ")
		assert r_space != nil	
		
		#el id es numerico  130022282960715776
		r_numeric = t.get_twit_by_id(130022282960715776)
		assert r_numeric != nil	
		
		#el id es string sin espacios  
		r_string = t.get_twit_by_id("130022282960715776")
		assert r_string != nil	
		
		#las 3 respuestas coinciden
		assert_equal r_space.response["results"], r_numeric.response["results"]
		assert_equal r_space.response["results"], r_string.response["results"]
  end
  
  def test_get_twit_by_id_not_found
  	t = TwitterController.new
  	
		#id no numerico
		assert_equal t.get_twit_by_id("sab").is_success?, false 
		
		#id 0
		assert_equal t.get_twit_by_id(0).is_success?, false 

		#id nil
		assert_equal t.get_twit_by_id(nil).is_success?, false 
		
		#id negativo 
		assert_equal t.get_twit_by_id(-3).is_success?, false 
		
		#id vacio
		assert_equal t.get_twit_by_id("").is_success?, false  
				
		#id no existe
		assert_equal t.get_twit_by_id(1).is_success?, false 
  end
  
  def test_get_user_information_by_id_ok
  	t = TwitterController.new
  	  	
		#el id tiene espacios
		r_space = t.get_user_information_by_id("   783214 ")
		assert r_space != nil
		assert r_space.response.size == 1
		
		#el id es numerico  783214
		r_numeric = t.get_user_information_by_id(783214)
		assert r_numeric != nil
		assert r_numeric.response.size == 1
		
		#el id es string sin espacios    
		r_string = t.get_user_information_by_id("783214")
		assert r_string != nil
		assert r_string.response.size == 1
		
		#las 3 respuestas coinciden
		assert_equal r_space.response[0]["id"], r_numeric.response[0]["id"]
		assert_equal r_space.response[0]["id"], r_string.response[0]["id"]
  end
  
  def test_get_user_information_by_id_not_found
  	t = TwitterController.new
  	  	
		#id no numerico
		assert_equal t.get_user_information_by_id("ddd").is_success?, false 
		
		#id 0
		assert_equal t.get_user_information_by_id(0).is_success?, false 
		
		#id negativo 
		assert_equal t.get_user_information_by_id(-90).is_success?, false 
		
		#id nil 
		assert_equal t.get_user_information_by_id(nil).is_success?, false 
		
		#id vacio 
		assert_equal t.get_user_information_by_id("").is_success?, false 
		
		#id no existe
		assert_equal t.get_user_information_by_id(1).is_success?, false 
		
  end  
  
end
