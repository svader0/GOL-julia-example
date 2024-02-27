# make a grid of random states
function initialize_grid(rows, cols)
    return rand(Bool, rows, cols)
end

function print_grid(grid)
    # The Julia vscode plugin said to use "eachindex" instead of iterating by the size of the grid
    # It seems to be some kind of optimization thing...
    for row in eachindex(grid[:, 1])
        for col in eachindex(grid[1, :])
            print(grid[row, col] ? "■ " : "□ ") # LaTeX ftw
        end
        println()
    end
end

function count_neighbors(grid, row, col)
    num_neighbors = 0
    directions = # just gonna hard code these in here...
        [(1, 0), (1, 1), (0, 1), (-1, 1),
            (-1, 0), (-1, -1), (0, -1), (1, -1)]

    for (dr, dc) in directions
        r = (row + dr)
        c = (col + dc)

        # Check if the neighbor we're looking at is in the bounds of our grid
        # I ♡ 1-indexing (lie)
        if 1 <= r <= size(grid, 1) && 1 <= c <= size(grid, 2)
            num_neighbors += grid[r, c]
        end
    end

    return num_neighbors
end

# for all of the spots in our grid, we just change states according to the rules of the game of life
function evolve_grid(grid)
    # start fresh with a new grid so we don't mess up our calculations
    new_grid = falses(size(grid))

    for row in eachindex(grid[:, 1])
        for col in eachindex(grid[1, :])
            num_neighbors = count_neighbors(grid, row, col)

            # These are just the rules for the game of life
            if grid[row, col]
                if num_neighbors < 2 || num_neighbors > 3
                    new_grid[row, col] = false
                else
                    new_grid[row, col] = true
                end
            else
                if num_neighbors == 3
                    new_grid[row, col] = true
                end
            end
        end
    end

    return new_grid
end

# Full disclosure: I stole this function from Stack Overflow
function clear()
    if Sys.iswindows()
        return read(run(`powershell cls`), String)
    elseif Sys.isunix()
        return read(run(`clear`), String)
    elseif Sys.islinux()
        return read(run(`printf "\033c"`), String)
    end
end



# Initialize our grid
rows = 15
cols = 15
grid = initialize_grid(rows, cols)

# Print the initial grid
println("Initial Grid:")
print_grid(grid)
println()

# Evolve the grid for a few steps and print each step
num_steps = 20
for step in 1:num_steps
    clear() # clear the terminal for prettyness
    # I have to include an emoji now that I discovered you can type them with the \: syntax
    println("🦶 Step $step:")
    global grid = evolve_grid(grid)
    print_grid(grid)
    println() # new line for posterity
    sleep(0.3) # sleep for a bit so we can observe the beautiful grid
end
