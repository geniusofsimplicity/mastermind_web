require "sinatra"
require "sinatra/reloader" if development?
load  "./mastermind.rb"
use Rack::Session::Pool, :expire_after => 2592000

# enable :sessions

get "/*" do
	game = Mastermind.setup_game("Pasha")
	board = game.get_board
	session["game"] = game 
	colours = game.get_colours
	victory = false
	give_up = false
	erb :index, {locals: {give_up: give_up, board: board, colours: colours, victory: victory}}
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
	puts "second_colour #{ second_colour}"
	puts "third_colour #{ third_colour}"
	puts "fourth_colour #{ fourth_colour}"
	puts "game #{game.class}" if !game.is_a? Mastermind
	game = Mastermind.setup_game("Pasha") if !game.is_a? Mastermind
	guess = [first_colour, second_colour, third_colour, fourth_colour]
	feedback = game.process_turn(guess)
	board = game.get_board
	
	session["game"] = game
	victory = game.victory?
	if victory || board.size == 12
		code = game.get_code
	end
	give_up = false
	puts "code #{game.get_code}"
	colours = game.get_colours
	erb :index, {locals: {give_up: give_up, board: board, colours: colours, victory: victory, code: code}}
end

post '/give_up' do
	game = session[:game]	
	board = game.get_board	
	code = game.get_code
	colours = game.get_colours
	victory = false
	give_up = true
	erb :index, {locals: {give_up: give_up, board: board, colours: colours, victory: victory, code: code}}
end

post '/restart' do
	puts "*******restart received"
	game = Mastermind.setup_game("Pasha")
	board = game.get_board
	session["game"] = game 
	colours = game.get_colours
	victory = false
	give_up = false
	erb :index, {locals: {give_up: give_up, board: board, colours: colours, victory: victory}}
end

post '/' do
	puts "*******received"
end