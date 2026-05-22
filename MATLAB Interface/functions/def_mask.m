function [ mask ] = def_mask(p, seed )
    %Generate mask values , with seed for reproducibility
    rng(seed)
    masks = -1+2*rand(1,p.n_neurons);    
%     masks = importdata('db\mskdb_10x50.mat');

        %FOR CHIPSCOPE DEBUG
%     masks = zeros(1, p.n_neurons);
%     masks(1) = 1;
%     masks(20) = 1;
%     masks(15) = 1;

    mask  = masks(1,:)*0.9; 
    clear masks;
end

