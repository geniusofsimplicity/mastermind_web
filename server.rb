require "sinatra"
require "sinatra/reloader" if development?
load  "./mastermind.rb"
use Rack::Session::Pool, :expire_after => 2592000

# enable :sessions

get "/" do
	# game = session[:game] 
	# game = Mastermind.setup_game("Pasha") if !game.is_a? Mastermind
	game = Mastermind.setup_game("Pasha")
	# guess = [first_colour, second_colour, third_colour, fourth_colour]
	# feedback = game.process_turn(guess)
	board = game.get_board
	session["game"] = game
	colours = game.get_colours
	victory = false
	erb :index, {locals: {board: board, colours: colours, victory: victory}}
end

post '/new_move' do
  game = session[:game]
  puts "//////////// in the post //////////////"
	# puts "code = #{game.print_code}"
	puts "game = #{game}" 
	first_colour = params[:first_colour]
	second_colour = params[:second_colour]
	third_colour = params[:third_colour]
	fourth_colour = params[:fourth_colour]
	puts "first_colour #{ first_colour}"
	puts "game #{game.class}" if !game.is_a? Mastermind
	game = Mastermind.setup_game("Pasha") if !game.is_a? Mastermind
	guess = [first_colour, second_colour, third_colour, fourth_colour]
	feedback = game.process_turn(guess)
	board = game.get_board
	puts "code = #{game.print_code}"
	session["game"] = game
	victory = game.victory?	
	colours = game.get_colours
	erb :index, {locals: {board: board, colours: colours, victory: victory}}
end