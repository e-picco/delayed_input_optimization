function [inputs, targets ] = gen_MG_data ( n_symbols, seed )
% Generate inputs and targets for the NARMA10 task
% Written by Enrico Picco, Feb 2021


%% The theory
% Mackey-Glass time series refers to the following, delayed differential
% equation:
% $$\frac{dx(t)}{dt}=\frac{ax(t-\tau)}{1+x(t-\tau)^{10}}-bx(t)

%% Input parameters
a        = 0.2;     % value for a in eq (1)
b        = 0.1;     % value for b in eq (1)
tau      = 17;		% delay constant in eq (1)
x0       = 1.2;		% initial condition: x(t=0)=x0
deltat   = 1;	    % time step size (which coincides with the integration step)
interval = 1;	    % output is printed at every 'interval' time steps

s_out = 10; %OUTPUT DELAY
sample_n = 2*n_symbols;	% total no. of samples, excluding the given initial condition



%% Main algorithm
% * x_t             : x at instant t         , i.e. x(t)        (current value of x)
% * x_t_minus_tau   : x at instant (t-tau)   , i.e. x(t-tau)
% * x_t_plus_deltat : x at instant (t+deltat), i.e. x(t+deltat) (next value of x)
% * X               : the (sample_n+1)-dimensional vector containing x0 plus all other computed values of x
% * T               : the (sample_n+1)-dimensional vector containing time samples
% * x_history       : a circular vector storing all computed samples within x(t-tau) and x(t)

time = 0;
index = 1;
history_length = floor(tau/deltat);
x_history = zeros(history_length, 1); % here we assume x(t)=0 for -tau <= t < 0
x_t = x0;

X = zeros(sample_n+1, 1); % vector of all generated x samples
T = zeros(sample_n+1, 1); % vector of time samples

for i = 1:sample_n+1,
    X(i) = x_t;
    if (mod(i-1, interval) == 0),
%         disp(sprintf('%4d %f', (i-1)/interval, x_t));
    end
    if tau == 0,
        x_t_minus_tau = 0.0;
    else
        x_t_minus_tau = x_history(index);
    end

    x_t_plus_deltat = mackeyglass_rk4(x_t, x_t_minus_tau, deltat, a, b);

    if (tau ~= 0),
        x_history(index) = x_t_plus_deltat;
        index = mod(index, history_length)+1;
    end
    time = time + deltat;
    T(i) = time;
    x_t = x_t_plus_deltat;
end


% figure
% plot(T, X);
% set(gca,'xlim',[0, T(end)]);
% xlabel('t');
% ylabel('x(t)');
% title(sprintf('A Mackey-Glass time serie (tau=%d)', tau));

% warmup = 1;
% inputs =  X(warmup:n_symbols+warmup);
% targets = X(warmup+s_out:n_symbols+warmup+s_out);
inputs =  X(1:n_symbols);
targets = X(1+s_out:n_symbols+s_out);

end

function x_t_plus_deltat = mackeyglass_rk4(x_t, x_t_minus_tau, deltat, a, b)
    k1 = deltat*mackeyglass_eq(x_t,          x_t_minus_tau, a, b);
    k2 = deltat*mackeyglass_eq(x_t+0.5*k1,   x_t_minus_tau, a, b);
    k3 = deltat*mackeyglass_eq(x_t+0.5*k2,   x_t_minus_tau, a, b);
    k4 = deltat*mackeyglass_eq(x_t+k3,       x_t_minus_tau, a, b);
    x_t_plus_deltat = (x_t + k1/6 + k2/3 + k3/3 + k4/6);
end

function x_dot = mackeyglass_eq(x_t, x_t_minus_tau, a, b)
    x_dot = -b*x_t + a*x_t_minus_tau/(1 + x_t_minus_tau^10.0);
end
