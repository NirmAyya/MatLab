function MyceliumDynamics()


%{ 
this code runs a forward-step method on a system of partial differential equations simulating the growth dynamics of mycelium
this code was our numerical simulation for our proposed system
it simulates the system, displays and saves a video of the progression of the system
you can play around with initial conditions and growth parameters to simulate various systems
unrealistic growth parameters or ill-defined initial conditions may cause the system to no longer be an accurate system
to model the dynamics of mycelium growth
%}


%{ 
v = tip extension rate
a1 =time constant for tip birth or death
a2 = number of branching per mm hyphae per hour
b1 = rate of tip reconnection per tip per hour
b2= rate of tip reconnection per mm hyphae per hour
b3 = rate at which overcrowding eliminates hyphae
G = rate of spontaneous hyphal death
D= diffusion rate of nutrients
Pn= function of x and t for nutrient density
Pm = function of x and t for mycelium density
n= function of x and t for number of tips per point (this is an average, no
need to discretize)
E= mycelium absorption rate of nutrients
F= tip absorption rate of nutrients
%}

% Parameters
v = .2;
a1 = 0.05;
a2 = 0.6;
b1 = 0.4;
b2 = 0.6;
b3 = 0.0001;
G = 0.0001;
D = 0.01;
E = 0.3;
F=0.5;

% Simulation settings
t_max = 5; % Total time
dt = 0.005; % Time step
R = 5; % Simulation range, -R <= x <= R
dx = 0.01; % Spatial step
x = -R:dx:R; % Spatial grid
N = length(x); % Number of spatial points
time_steps = round(t_max / dt); % Number of time steps

% Initial conditions
Pm = zeros(size(x)); % Initial mycelium density
n = cos(x)+2; % Initial number of tips ('sinusoidal' distribution)
Pn = zeros(size(x)); % Initial nutrient density (smear on the growth plate)
Pn(abs(x) <= 1) = .3; % Set P = 1 for -1 <= x <= 1

% Initialize lists for storing results
Pm_results = zeros(time_steps, N);
n_results = zeros(time_steps, N);
Pn_results = zeros(time_steps, N);

% Store the initial conditions
Pm_results(1, :) = Pm;
n_results(1, :) = n;
Pn_results(1, :) = Pn;

% Plotting settings
figure;

% Ask user for the filename to save the video
videoFileName = input('Enter the filename for the video (e.g., simulation.mp4): ', 's');
videoWriter = VideoWriter(videoFileName, 'MPEG-4');
open(videoWriter);

for t = 2:time_steps
    % Update Pm using the given equation
    Pm_new = Pm + dt * (v * n - G * Pm + F * Pm .* Pn);
    
    % Update n using the given equation
    nv = v .* n;
    dnv_dx = (circshift(nv, -1) - circshift(nv, 1)) / (2 * dx);
    n_new = n + dt * (-dnv_dx + a1 * n + a2 * Pm - b1 * n.^2 - b2 * n .* Pm - b3 * Pm.^2 + F * Pn .* n);
    
    % Update Pn using the given equation
    lap_Pn = (circshift(Pn, -1) - 2 * Pn + circshift(Pn, 1)) / dx^2;
    Pn_new = Pn + dt * (D * lap_Pn - E * Pm .* Pn - F * Pn .* n);
    
    % Apply Neumann boundary conditions (zero gradient at the boundaries)
    Pm_new(1) = Pm_new(2);
    Pm_new(end) = Pm_new(end-1);
    n_new(1) = n_new(2);
    n_new(end) = n_new(end-1);
    Pn_new(1) = Pn_new(2);
    Pn_new(end) = Pn_new(end-1);

    % If Pn is negative, make it 0
    Pn_new(Pn_new < 0) = 0;
    
    % Update variables for the next time step
    Pm = Pm_new;
    n = n_new;
    Pn = Pn_new;

    % Store the values at the current time step
    Pm_results(t, :) = Pm;
    n_results(t, :) = n;
    Pn_results(t, :) = Pn;

    % Clear current figure and plot new graphs
    clf;
    subplot(3, 1, 1);
    plot(x, Pm, '.');
    xlabel('Position (x)');
    ylabel('Mycelium Density (Pm)');
    title(['Mycelium Density at Time Step ' num2str(t)]);
    ylim([0 3]); % Set y-axis limits

    subplot(3, 1, 2);
    plot(x, n, '.');
    xlabel('Position (x)');
    ylabel('Number of Tips (n)');
    title(['Number of Tips at Time Step ' num2str(t)]);
    ylim([0 3]); % Set y-axis limits

    subplot(3, 1, 3);
    plot(x, Pn, '.');
    xlabel('Position (x)');
    ylabel('Nutrient Density (Pn)');
    title(['Nutrient Density at Time Step ' num2str(t)]);
    ylim([0 1]); % Set y-axis limits

    % Pause to show the progression
    pause(0.01); 

    % Capture the current figure as a frame and write to the video
    frame = getframe(gcf);
    writeVideo(videoWriter, frame);

    invalid_indices = find(Pm_new < 0 | n_new < 0);
    if ~isempty(invalid_indices)
        disp('Negative values found:');
        disp(['Pn: ' num2str(Pn_new(invalid_indices))]);
        disp(['Pm: ' num2str(Pm_new(invalid_indices))]);
        disp(['n: ' num2str(n_new(invalid_indices))]);
        break;
    end
end

% Close the video writer object
close(videoWriter);
disp(['Video saved as ' videoFileName]);

% Optionally, you can return the results for further analysis
% result = struct('Pm_results', Pm_results, 'n_results', n_results, 'Pn_results', Pn_results);
end
