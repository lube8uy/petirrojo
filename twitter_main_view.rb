require File.expand_path(File.dirname(__FILE__) + '/twitter_controller.rb')

controller = TwitterController.new

def show_menu
	p "Para realizar una accion teclea el numero a su izquierda seguido de un enter"
	p "1. Obtener trends del momento"
	p "2. Obtener los twits para un trend"
	p "3. Obtener los datos de un usuario"
	p "4. Mostrar menu de acciones"
	p "5. Salir"
end

p "Petirrojo, un pequeno cliente para twitter"
p "-----------------------------------------------------------------------------"
show_menu

#p controller.get_trends

#p controller.get_twits_for_trend("moyano")
