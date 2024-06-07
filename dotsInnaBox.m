function dotsInnaBox()

% x and y dimensions
Xmax = 5;
Ymax = 5;
% simulation runs in region enclosed by [0,x] and [x,y]

% initialize a starting point
point = [1, 1];

% pick a direction to travel in
x = point;
z = zeros(1, 2);
for i = 1:2
    z(i) = (2 * Xmax) * (rand(1) - 0.5);
end

% scale the point down so it isn't super large jumps
z = 0.01 * z;

% set up the figure
figure;
hold on;
axis([0 Xmax 0 Ymax]);
h = plot(x(1), x(2), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% start a while loop
n = 1;
while n > 0
    % update the dot position
    x = x + z;

    % see if we need to change the travel direction

    % case 1 we go past the x boundaries
    % goes past x=0
    if x(1) <= 0
        x(1) = 0;
        z(1) = -z(1);
    end
    % goes past x=Xmax
    if x(1) >= Xmax
        x(1) = Xmax;
        z(1) = -z(1);
    end
    % case 2 we go past the y boundaries
    if x(2) <= 0
        x(2) = 0;
        z(2) = -z(2);
    end
    % goes past y=Ymax
    if x(2) >= Ymax
        x(2) = Ymax;
        z(2) = -z(2);
    end

    % update the display
    set(h, 'XData', x(1), 'YData', x(2));
    drawnow;
    pause(0.01); % pause to slow down the display
end

end
