include Math

input_board = [
    7, 0, 0, 4, 0, 9, 0, 0, 6,
    5, 0, 9, 0, 8, 6, 1, 2, 0,
    1, 4, 0, 0, 0, 0, 0, 0, 0,
    6, 5, 0, 8, 0, 0, 0, 0, 0,
    0, 2, 4, 9, 0, 1, 5, 6, 0,
    0, 0, 0, 0, 0, 2, 0, 1, 8,
    0, 0, 0, 0, 0, 0, 0, 8, 7,
    0, 7, 5, 2, 4, 0, 6, 0, 1,
    2, 0, 0, 3, 0, 7, 0, 0, 5]

class SudokuSolver
	# the board field
	@board = nil

    # the board length
    @board_length = 0

    # the board size (the square side)
    @board_size = 0

    # the internal block size
    @block_size = 0

    # initializer
	def initialize(board)
		# board must be valid
        if not is_board_valid(board) then
            raise Exception.new("Invalid Board.")
        end

        # setting board
        @board = board

        # setting board size
        @board_length = board.size()

        # setting square side size
        @board_size = sqrt(@board_length).to_i()

        # setting block size
        @block_size = sqrt(@board_size).to_i()
	end

	def solve()
	end

    def is_board_valid(board)
        # total size must be a perfect square number
        board_length = board.size()

        # if is indeed a perfect square
        board_size = sqrt(board_length).to_i()
        if board_size * board_size != board_length then
            return false
        end

        # it must be again a perfect square number
        block_size = sqrt(board_size).to_i()
        if block_size * block_size != board_size then
        	return false
        end

        return true
    end

    def print_sudoku_board(board)
        board_length = board.size()
        dim = sqrt(board_length).to_i()
        blk_size = sqrt(dim).to_i()

        blk_parts = ['-' * (blk_size * 2 + 1)] * blk_size
        h_line = "-#{blk_parts.join('+')}-"

        for r in 0..(dim-1)
        	if r % blk_size == 0 then
        		puts(h_line)
        	end

        	curr_line = '| '
        	for c in 0..(dim-1)
        		curr_line += "#{board[r * dim + c]} "

        		if c % blk_size == (blk_size - 1) then
        			curr_line += '| '
        		end
        	end

        	puts(curr_line)
        end

        puts(h_line)
    end

    def print_board()
        print_sudoku_board(@board)
    end
end

# -----------------------------------------------------------------------

class NaiveSudokuSolver < SudokuSolver

	# label for each row
    @row_labels = nil

    # label for each column
    @col_labels = nil

    # label for each internal block
    @sqr_labels = nil

    def initialize(board)
    	# calling base initializer
    	super(board)

    	# computing labels
        @row_labels, @col_labels, @sqr_labels = get_labels()

        # checking labels 'correctess'
        if @row_labels == nil or @col_labels == nil or @sqr_labels == nil then
            raise Exception.new("Board integrity is compromised")
        end
    end

    def solve()
    	# making a copy of the board
        board = @board.clone()

        # getting the empty positions
        empty_list = get_empty_positions(board)

        # returning the solved sudoku
        return solve_backtrack(board, empty_list)
    end

    def solve_backtrack(board, empty_list)
        empty_list_size = empty_list.size()
        if empty_list_size < 1 then
            return board
        end

        # getting first empty position
        index = empty_list[0]

        invalid_values = get_invalid_values(board, index)
        possible_values = get_possible_values(invalid_values)
        for j in possible_values
            # setting possible value
            board[index] = j

            # solving by backtraking
            solution = solve_backtrack(board, empty_list[1, empty_list_size - 1])

            # if solved then return solution
            if solution != nil then
                return solution
            end

            # taking back that change
            board[index] = 0
        end

        return nil
    end

    def get_empty_positions(board)
        board_length = board.size()
        result = Array.new()

        for i in 0..(board_length - 1)
            if board[i] == 0 then
                result << i
            end
        end

        return result
    end

    def get_labels()
        board_length = @board_length
        board_size = @board_size
        block_size = @block_size

        rows = Array.new(board_length)
        cols = Array.new(board_length)
        squares = Array.new(board_length)

        for i in 0..(board_length - 1)
            row_label = i / board_size
            col_label = i % board_size

            a = board_length / block_size
            b = row_label / block_size
            c = col_label / block_size
            square_label = a * b + c

            rows[i] = row_label
            cols[i] = col_label
            squares[i] = square_label
        end

        return rows, cols, squares
    end

    def get_invalid_values(board, k)
        result = Array.new()

        for j in 0..(board.size() - 1)
            if @col_labels[k] == @col_labels[j] or @row_labels[k] == @row_labels[j] or @sqr_labels[k] == @sqr_labels[j] then
                result << board[j]
            end
        end

        return result
    end

	def get_possible_values(invalid_values)
		# simple set difference
		all_values = (1..(@board_size)).to_a()
		return all_values - invalid_values
	end
end