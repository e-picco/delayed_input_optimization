function [inputs, targets ] = gen_NARMA_data ( n_symbols, seed )
    % Generate inputs and targets for the NARMA10 task
    % Written by Enrico Picco, Feb 2021

    rng(seed);
    systemorder = 10;
   
    %input 
    d= 0.5*rand(1,n_symbols + systemorder); %1x1010 input vector
    
    %output allocation (because we need to go 10 timesteps in the past)
    u = zeros(1,n_symbols + systemorder); %1x1010
    
    %output
    for n=systemorder+1:n_symbols+systemorder %for n=11:1010
        
         u(n) = 0.3*u(n-1) + 0.05*u(n-1)*sum(u(n-1:n-10)) + 1.5*d(n-1)*d(n-10) + 0.1;
    end
    
    % we discard the first 10 inputs 
    inputs =  u(systemorder+1:n_symbols+systemorder);
    targets = d(systemorder+1:n_symbols+systemorder);
end
