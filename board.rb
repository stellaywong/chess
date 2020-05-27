require 'pry'   #allows us to add binding.pry the debugger

class Board
    attr_reader :grid
    def initialize(rank, file)
       @grid = Array.new(rank) {Array.new(file) {"_"} }

       add_pieces
       render

       play until play == "exit"
    end

    # def get_piece(rank, file)
    #     @grid[rank][file]
    # end

    def play
        puts "What's the next move?"
        console_input = gets.chomp
        if console_input != "exit"
            parse_move(console_input)
        else
            return
        end
    end

    def parse_move(console_input)
        start_string, finish_string = console_input.split(" ")
        
        alphabet = "HGFEDCBA"
        start_letter = start_string.split("")[0].upcase
        finish_letter = finish_string.split("")[0].upcase

        start_rank = alphabet.index(start_letter)
        finish_rank = alphabet.index(finish_letter)
        if (!start_rank || !finish_rank)
            puts "Vertical off the board!"
            return
        end
            
        start_file = start_string.split("")[1].to_i - 1
        finish_file = finish_string.split("")[1].to_i - 1

        [start_file, finish_file].each do |coordinate|
            if coordinate < 0 || coordinate > 7
                puts "Horizontal off the board!"
                return
            end
        end

        move(start_rank, start_file, finish_rank, finish_file)
    end

    def move(start_rank, start_file, finish_rank, finish_file)
        start = @grid[start_rank][start_file]
        finish = @grid[finish_rank][finish_file]
        rank_move = (finish_rank - start_rank)
        file_move = (finish_file - start_file)

        if start.is_a?(Piece)
            if start.is_valid?(rank_move, file_move)
                move_type(finish)
                move_to(@grid, start_rank, start_file, finish_rank, finish_file)
            else
                puts "Invalid Move!"
                return
            end
        else
            puts "Can't move an empty square!"
        end

        render
    end

    def move_type(finish)
        if finish == "_"
            puts "Valid Move!"
        else #if finish.is_a?(Piece)
            puts "Captured!"
        end
    end

    def move_to(grid, start_rank, start_file, finish_rank, finish_file)
        @grid[finish_rank][finish_file] = @grid[start_rank][start_file]
        @grid[start_rank][start_file] = "_"
    end

    # call methods from inside methods, not from outside (in the class space)

    private     #can't call method from outside

    def render
        letters = "HGFEDCBA"
        letter_idx = 0

        @grid.each do |rank|
            print letters[letter_idx] + " "
            letter_idx += 1

            rank.each do |piece|
                if piece.is_a?(Piece)
                    print piece.name + " "
                else
                    print piece + " "
                end
            end
            puts

        end

        print "  "
        (1..8).each { |num| print num.to_s + " " }
        puts
        
    end

    def add_pieces
       add_pawns(1, "Black")
       add_pawns(6, "White")
       add_non_pawns(0, "Black")
       add_non_pawns(7, "White")
    end

    def add_pawns(rank, color)
        (0..7).each do |file|
            @grid[rank][file] = Pawn.new(rank, file, color)
        end
    end

    def add_non_pawns(rank, color)
        [0, 7].each { |file| @grid[rank][file] = Rook.new(rank, file, color) }
        [1, 6].each { |file| @grid[rank][file] = Knight.new(rank, file, color) }
        [2, 5].each { |file| @grid[rank][file] = Bishop.new(rank, file, color) }
        [3].each { |file| @grid[rank][file] = Queen.new(rank, file, color) }
        [4].each { |file| @grid[rank][file] = King.new(rank, file, color) }
    end
end

class Game
    # attr_reader :board
    # def initialize(rank, file)
    #     @grid = Board.new(rank, file)

    #     p @grid.get_piece(0, 0)
        # play until play == "exit"
    # end

end

class Piece
    attr_reader :color
    attr_accessor :rank, :file
    def initialize(rank, file, color)
        @rank = rank
        @file = file
        @color = color
    end
end

class Pawn < Piece
    def name
        "P"
    end

    def is_valid?(rank_move, file_move)
        if color == "Black"
            rank_move == 1
        else
            rank_move == -1
        end
    end
end

class Rook < Piece
    def name
        "R"
    end

    def is_valid?(rank_move, file_move)
        return (rank_move.abs && file_move == 0) || (rank_move == 0 && file_move.abs)
    end
end

class Knight < Piece
    def name
        "k"
    end

    def is_valid?(rank_move, file_move)
        rank_move.abs * file_move.abs == 2
    end
end

class Bishop < Piece
    def name
        "B"
    end

    def is_valid?(rank_move, file_move)
        rank_move.abs == file_move.abs
    end
end

class Queen < Piece
    def name
        "Q"
    end

    def is_valid?(rank_move, file_move)
        return (rank_move.abs && file_move == 0) || (rank_move == 0 && file_move.abs) || (rank_move.abs == file_move.abs)
    end
end

class King < Piece
    def name
        "K"
    end

    def is_valid?(rank_move, file_move)
        (rank_move.abs * file_move.abs == 0) || (rank_move.abs * file_move.abs == 1)
    end
end

# @newthing = Game.new(8,8)
@newthing = Board.new(8,8)
p @newthing.class


# @newthing.parse_move("G1 F1")
# @newthing.parse_move("H2 F3")

# @newthing.move(1,0,2,0)
# @newthing.move(1,1,2,1)
# @newthing.move(0,2,3,5)
# @newthing.move(0,1,2,2)
# @newthing.move(0,6,2,5)
# @newthing.move(2,5,3,7)
# @newthing.move(1,4,2,4)
# @newthing.move(0,4,1,4)
# @newthing.move(1,4,2,5)

# @newpawn = Pawn.new(0,0,"white").name

# return only makes sense in a function; otherwise (outside of a class) it's a syntax error

# p @newthing.get_piece(0,0)
# @newthing.move(1,0,2,0)

