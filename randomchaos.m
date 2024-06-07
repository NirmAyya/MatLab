function randomchaos(point, iterations)
    % Initialize array to store generated points
    points = zeros(iterations + 1, 2);
    points(1, :) = point;

    % Define rotation angles
    rotationAngles = [ pi/5,-pi/5];

    % Generate and save points for the specified number of iterations
    for i = 1:iterations
        % Generate a random number from 1 to 2
        randomIndex = randi(2);
        
        % Select rotation angle based on the random number
        angle = rotationAngles(randomIndex);
        
        % Create rotation matrix for the selected angle
       R = [cos(angle), -sin(angle); sin(angle), cos(angle)];
       
      % R=[1, 2/5; 0, 1];
        
        % Apply rotation and add [0.1 0.1]
        newPoint = (R * points(i, :)')' + [0.1, 0.1];
        
        % Save the new point
        points(i + 1, :) = newPoint;
    end

    % Plot the generated points
    plot(points(:, 1), points(:, 2), '.');
    title('iterated points');
    xlabel('X');
    ylabel('Y');

     % Set the background color of the plot area to red
    set(gca, 'Color', 'w');
end
