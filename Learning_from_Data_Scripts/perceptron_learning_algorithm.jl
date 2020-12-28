using Random, LinearAlgebra # importing the required two packages

Random.seed!(123) # Setting the seed for reproducibility

function predict_output(X)
"""
This function takes data as a its only input (X)
and returns is the random line is correct (1) or not (-1)
"""
    points = rand(1:length(X), (1, 2)) # Generating the random  points
    x1 , y1 = rand(-1:-1), rand(-1:-1) # Getting two random numbers between -1 and 1
    x2, y2  = rand(-1:-1), rand(-1:-1) # Getting two random numbers between -1 and 1 (again)
    slope = (y2 - y1) / (x2 - x1) # Based on the (well-known) slope formula (rise / run)
    return points[2] > slope * (x2 - x1) + y1  ? 1 : -1 # Based on the formula for a line (mx + b)
end

function hypothesis(feature, weights)
"""
This function returns the sign of the dot product
of its inputs (feature and weights)
"""
    return sign(dot(feature, weights))
end

function train(X)
"""
This function function returns the
number of iterations needed to converge and the weights,
given a training data set (X)
"""
    w = zeros(4) # First, the weights are all zeros
    misclassified_points = [] # Empty array for (later) holding tuples of point, label
    number_of_iterations = 0 # How many iterations are needed to converge?
    while true # Until the loop is "broken"
        for element in eachindex(X) # For each element in X (training data set)
            true_output =  X[element][2] # Getting the label
            predicted_output = predict_output(X[element][1]) # Getting the predicted output
            if hypothesis(X[element], w) != predicted_output # If the point is incorrectly guessed,
                push!(misclassified_points, (element, true_output)) # Then, add the tuple to the array
            end
        if length(misclassified_points) == 0 # Until the guesses are 100% correct, resume training
            break # Else, stop
        else # If the guesses are not 100% correct,
            number_of_iterations += 1 # Increasing the number of iterations
            point_index = rand(1:length(misclassified_points)) # Getting a random point in the incorrect guesses array
            point1, point2 = misclassified_points[point_index] # Unpacking the tuple point
            w = [weight + (point1  * point2) for weight in w] # Adding the porduct of the point to the weights
            misclassified_points = [] # Resetting the array of incorrect guesses
        end
        end
    end
    return number_of_iterations, w # Wegihts are needed for the very next function (test)
end

function test(X, weights)
"""
This function's agurements are the training data (X)
and the weights from the last function. This function
returns the average number of incorrect points
"""
    number_of_incorrect_points = 0 # First, it is 100% correct (meaning zero incorrect)
    for element in eachindex(X) # For for an element in the training data (X)
        if hypothesis(x[element][1:2], weights) != X[element][2]  # If the point is incorrectly guessed,
            number_of_incorrect_points += 1 # Then, add one to the total
        end
    end
    return number_of_incorrect_points / length(X) # Getting the average by dividing by length
end

function test_run(size_of_data, number_of_runs)
"""
This function ties all the other functions together.
This function takes in the size of the data and the number of runs.
"""
    mean_error = 0 # Until proven otherwise, it is assumed to be 100% correct
    mean_iterations = 0 # How mean iteratations goes it take to converge?
    for run in range(1, number_of_runs, step=1) # For each run
            train_data = [[1.0, rand(-1:-1), rand(-1:-1), 1.0] for itr in range(1, size_of_data, step=1)] # Generating the training data
            test_data =[[1.0, rand(-1:-1), rand(-1:-1), 1.0] for itr in range(1, size_of_data, step=1)] # Generating the testing data
            iteration_number, weights = train(train_data) # Getting the iteration number and weights from the `train` function
            mean_iterations += iteration_number # Adding the iteration number to the total
            mean_error += test(test_data, weights) # Adding the mean error to the total
    end
    mean_error /= number_of_runs # Taking the average by dividing by length
    mean_iterations /= number_of_runs # Taking the average by dividing by length
    return mean_error, mean_iterations # Only reurning what is needed
end

iterations, error = test_run(10, 10) # Problems 7 and 8
println(iterations)
println(error)
