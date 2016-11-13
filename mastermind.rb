class Mastermind

	def self.setup_game(name)
		# colours = %q{magenta green blue yellow darkorange black white indigo saddlebrown cyan}.split
		colours = [	"rgb(255, 0, 255)", 	#magenta
								"rgb(0, 128, 0)", 		#green
								"rgb(0, 0, 255)",			#blue
		 						"rgb(255, 255, 0)",		#yellow
								"rgb(255, 140, 0)",		#orange
								"rgb(0, 0, 0)",				#black
								"rgb(255, 255, 255)", #white
								"rgb(75, 0, 130)", 		#indigo
								"rgb(139, 69, 19)", 	#brown
								"rgb(0, 255, 255)"]		#cyen
		# colours = %q{magenta green blue yellow darkorange black white indigo saddlebrown cyan}.split
		board = Board.new(colours)

		code_breaker = CodeBreaker.new(name)		

		code_master = CodeMaster.new({colours: colours})

		game = Mastermind.new(code_breaker, code_master, board, nil)
		game
	end

	def start
		process_turns
	end	

	class CodeBreaker
		def initialize(name)
			@name = name			
		end

		def move			
			colours = Board.get_colours
		end
	end

	class Compluter < CodeBreaker
		def initialize(board)
			@board = board			
		end

		def move			
			bulls_n = @board.last_bulls
			cows_n = @board.last_cows
			last_row = @board.last_row
			pick = []
			pick = last_row.sample(bulls_n + cows_n) if last_row
			need_n = 4 - pick.size
			pick += Board.colours.sample(need_n) if need_n > 0
			pick
		end

	end

	class CodeMaster
		def initialize(mode)
			case
			when mode[:colours] then gen_code(mode[:colours])
			when mode[:code] 		then @code = mode[:code]
			else # TODO
			end			
		end

		def get_feedback(colours)
			bulls = 0
			cows = 0
			colours_left = []
			code_left = []
			colours.each_index do |i|
				if colours[i] == @code[i]
					bulls += 1 
				else
					colours_left << colours[i]
					code_left << @code[i]
				end
			end
			colours_left.each do |c|
				if i = code_left.find_index(c)
					cows += 1
					code_left.delete_at(i)
				end
			end
			{bulls: bulls, cows: cows}
		end

		def print_code
			@code.join(" ")
		end

		private

		def gen_code(colours)
			@code = []
			4.times do
				@code << colours.sample
			end			
		end
	end

	class Board
		attr_reader :colours, :board
		Row = Struct.new(:move, :result)

		def initialize(colours)	
			@board = []
			@l_just = colours.max.size
			@@colours = colours
		end

		def update(colours, feedback)
			@board << [colours, feedback]
		end

		def last_bulls
			@board.last ? @board.last[1][:bulls] : 0
		end

		def last_cows
			@board.last ? board.last[1][:cows] : 0
		end

		def last_row
			@board.last[0] if @board.last
		end

		def print
			@board.each_index do |i|
				row = @board[i]
				colours = row[0]
				feedback = row[1]
				puts "#{i + 1}: #{colours[0].ljust(@l_just + 2)} "\
						 					 "#{colours[1].ljust(@l_just + 2)} "\
						 					 "#{colours[2].ljust(@l_just + 2)} "\
						 					 "#{colours[3].ljust(@l_just + 2)} "\
						 					 "|| bulls: #{feedback[:bulls]}, cows: #{feedback[:cows]}"
			end		
		end

		def self.colours
			@@colours			
		end

		def validate_colours(colours)			
			colours.each do |c|
				return false unless @@colours.include?(c)
			end
			return false if @board.size > 0 && @board.last[0] == colours
			true			
		end

		def self.get_colours
			colours = nil
			until colours
				puts "Please, enter correct colours (#{@@colours.join(" / ")})."
				input = gets.chomp
				colours = input.split
				unless colours.size == 4
					colours = nil
					next
				end
				colours.each do |c|
					unless @@colours.include?(c)
						colours = nil
						next
					end
				end
			end			
			colours
		end

	end

	def process_turn(current_colours)		
		puts "validate_colours #{@board.validate_colours(current_colours)}"
		if @board.validate_colours(current_colours)
			feedback = @code_master.get_feedback(current_colours)
			@board.update(current_colours, feedback)
		end
	end

	def victory?
		@board.board.size > 0 && @board.board.last[1][:bulls] == 4
	end

	def print_code
		@code_master.print_code
	end

	def get_board
		@board.board
	end

	def get_colours
		Board.colours
	end

	private

	def initialize(code_breaker, code_master, board, computer)
		@code_breaker = code_breaker
		@code_master = code_master
		@board = board
		@computer = computer
	end
end

# game = Mastermind.setup_game
# game.start