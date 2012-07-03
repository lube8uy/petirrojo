require_relative 'twitter_view.rb'

print "Petirrojo, un pequeno cliente para twitter, bienvenido \n"
print "Para salir de cualquier opcion o del programa escribe 'exit' \n\n"

$view = TwitterView.new

def refresh_trends
	print "cargando trends....\n\n"
	print $view.get_trends	
	if $view.has_error?
		print "Twitter no esta disponible, vuelve a lanzar la aplicacion mas tarde\n"
	end
end

def read_option
	option = gets.strip.downcase
	return option
end

refresh_trends
option = "continue"

while option == "continue"
	if !$view.has_error?
		print "\nSi quieres ver los twitts de algun trend ingresa el numero a su izquierda, para refrescar los trends, escribe \"rf\" sino presiona cualquier tecla\n"
		print "> "
		option = read_option
		if option == "rf"
			refresh_trends
			option = "continue"
		else
			ok_trend = true
			while ok_trend
				begin	
					print $view.drill_down_trend(option)				
					ok_user = true
					while ok_user
						begin			
							print "\nSi quieres ver informacion del usario que creo un twit ingresa el numero a su izquierda, sino presiona cualquier tecla\n"	
							print "> "	
							option = read_option
							print $view.drill_down_user(option)
						rescue
							print "Hemos perdido la comunicacion con twitter\n" if $view.has_error?
							ok_user = false
							option = "continue"
						end
					end
				rescue
					print "Twitter no esta disponible, vuelve a lanzar la aplicacion mas tarde" if $view.has_error?
					ok_trend = false
				end
			end
		end
	else
		option = ""
	end
end

print "\nTwit, twit!\n"
