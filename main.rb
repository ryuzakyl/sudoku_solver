load "./sudoku_solver.rb"

def project_euler_tester()
    test_cases_path = './test_cases.txt'

    # opening file
    f = File.new(test_cases_path, "r")

    sum = 0

    # there are 50 test cases
    for i in 1..50
        board = load_test_case(f)

        sudoku_solver = NaiveSudokuSolver.new(board)
        answer = sudoku_solver.solve()

        sum += 100 * answer[0] + 10 * answer[1] + answer[2]

        puts("#{i} solved")
    end

    # closing file
    f.close()

    return sum
end


def load_test_case(f)
    # read header
    f.readline()

    s = ""

    # those are 9x9 sudoku puzzles
    for i in 1..9
        line = f.readline()
        s += line[0, line.size() - 1]
    end

    return str_to_int_list(s)
end


def str_to_int_list(s)
    result = Array.new()

    for i in 0..(s.size() - 1)
        result << s[i].to_i()
    end

    return result
end

# ---------------------------------------------------------------

sln = project_euler_tester()
puts("-----------------------------------------------------------")
puts("The solution is: #{sln}")