
function [inputs, targets ] = gen_LORENZ_data ( n_symbols )

out_delay=1;

% Parameters
sigma = 10;
beta = 8/3;
rho = 28;

% Initial conditions
x0 = 0;
y0 = 1;
z0 = 1.05;

% Time settings
dt = 0.02;
% T = 100; % Total simulation time
num_steps = n_symbols + out_delay; %RICK: so we include the future step, for the output
T = num_steps*dt + 1;
% num_steps = round(T / dt);

% Initialize arrays to store the time series
x = zeros(1, num_steps);
y = zeros(1, num_steps);
z = zeros(1, num_steps);

% Initialize the initial conditions
x(1) = x0;
y(1) = y0;
z(1) = z0;

% Numerical integration using the forward Euler method
for i = 1:num_steps - 1
    dx = sigma * (y(i) - x(i)) * dt;
    dy = (x(i) * (rho - z(i)) - y(i)) * dt;
    dz = (x(i) * y(i) - beta * z(i)) * dt;
    
    x(i+1) = x(i) + dx;
    y(i+1) = y(i) + dy;
    z(i+1) = z(i) + dz;
end


inputs  = x(  1  :  n_symbols);
targets = x(out_delay+1 : out_delay+n_symbols);
 %% plot 
% % Create a time vector
% t = 0:dt:(T-dt);
% 
% Plot the Lorenz time series
% figure;
% plot(t, x, 'r', t, y, 'g', t, z, 'b');
% xlabel('Time');
% ylabel('Value');
% legend('x', 'y', 'z');
% title('Lorenz Time Series');
% 
% % Optional: You can also create a 3D plot of the attractor
% figure;
% plot3(x, y, z);
% xlabel('x');
% ylabel('y');
% zlabel('z');
% title('Lorenz Attractor');
end
