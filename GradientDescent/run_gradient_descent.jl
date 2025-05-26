include("GradientDescent.jl") # Ensure GradientDescent.jl is in the same directory
using Plots
pyplot() # PyPlot 백엔드 사용 선언

# --- Example Code Start ---

# 1. Define the objective function and its gradient
# f(x) = (x[1] - 1)^2 + (x[2] - 2)^2
# This function has a minimum value of 0 at (1, 2).
f(x) = (x[1] - 1.0)^2 + (x[2] - 2.0)^2

# ∇f(x) = [2*(x[1] - 1), 2*(x[2] - 2)]
∇f(x) = [2.0 * (x[1] - 1.0), 2.0 * (x[2] - 2.0)]

# 2. Initialization settings
initial_x = [-1.0, -1.0] # Starting point
α = 0.1                 # Step factor (learning rate)
num_iterations = 50     # Number of iterations

# Create GradientDescent instance
gd_method = GradientDescent(α)
init!(gd_method, f, ∇f, initial_x) # Call init! (not highly significant here)

# Lists to store results
x_history = [initial_x]
f_history = [f(initial_x)]

current_x = initial_x

println("--- Starting Gradient Descent ---")
println("Iteration 0: x = $(current_x), f(x) = $(f(current_x))")

# 3. Run Gradient Descent
for i in 1:num_iterations
    global current_x # Use global keyword to modify global variable inside function
    current_x = step!(gd_method, f, ∇f, current_x)
    push!(x_history, current_x)
    push!(f_history, f(current_x))
    println("Iteration $i: x = $(current_x), f(x) = $(f(current_x))")

    # Convergence condition (optional): Stop if change in f(x) is very small
    if i > 1 && abs(f_history[end] - f_history[end-1]) < 1e-6
        println("Convergence condition met. Early exit.")
        break
    end
end

println("--- Gradient Descent Finished ---")
println("Final x = $(current_x)")
println("Final f(x) = $(f(current_x))")

# 4. Plotting Results
# Set x, y ranges for contour plot
x_range = -5.0:0.1:5.0
y_range = -4.0:0.1:4.0

# Calculate Z values (f(x, y) values)
Z = [f([x_val, y_val]) for y_val in y_range, x_val in x_range]

# Create filled contour plot using contourf
# Added 'c = :viridis' to specify colormap and suppress warning
p = contourf(x_range, y_range, Z,
            levels = 20, # Number of filled contour levels
            colorbar = true,
            c = :viridis, # <-- Added colormap specification (e.g., :viridis, :jet, :grays)
            title = "Gradient Descent Path",
            xlabel = "x1",
            ylabel = "x2",
            aspect_ratio = :equal)

# Extract x1 and x2 values from x_history
x1_coords = [x[1] for x in x_history]
x2_coords = [x[2] for x in x_history]

# Add Gradient Descent path to the plot
plot!(p, x1_coords, x2_coords,
      line = (:red, 2, :solid), # Red solid line for path
      marker = (:circle, 4, :white, :solid, 0.5), # Blue circle markers for each step
      label = "Gradient Descent Path") # This label is for the line, not the contourf

# Mark the minimum point
scatter!(p, [1.0], [2.0],
          marker = (:star, 8, :green, :solid), # Green star marker
          label = "Actual Minimum")

display(p) # Display the plot

# Plot change in f(x) values
plot(1:length(f_history), f_history,
      xlabel = "Iteration",
      ylabel = "f(x)",
      title = "Change in f(x) over Iterations",
      legend = false,
      marker = :circle)

println("\nPress Enter to close the plot and exit.")
readline() # Wait for user input. Script execution will pause until Enter is pressed.