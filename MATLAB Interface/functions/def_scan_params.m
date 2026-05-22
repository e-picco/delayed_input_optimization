function [ scan_params, scan_list, n_runs ] = def_scan_params (hp)

    % 1. set labels & values
    scan_params = struct();

    scan_params.lbls{1} = 'G2'; % Input Gain
    scan_params.vals{1} = hp.G2_scan;
    scan_params.vars{1} = 'hp.G2';
    scan_params.lens(1) = length(scan_params.vals{1});

    scan_params.lbls{2} = 'dly'; 
    scan_params.vals{2} = hp.dly_scan;
    scan_params.vars{2} = 'hp.dly';
    scan_params.lens(2) = length(scan_params.vals{2});
 
    scan_params.lbls{3} = 'MZb'; % MZ 1 DC Bias
    scan_params.vals{3} = hp.mzb_vals;
    scan_params.vars{3} = 'hp.mzb';
    scan_params.lens(3) = length(scan_params.vals{3});
   
    % 2. generate permutations list
    n_runs        = prod(scan_params.lens);
    n_scan_params = length(scan_params.lbls);
    scan_list     = zeros(n_scan_params, n_runs);

    % understanding this loop requires a pencil, a paper and some concentration
    % better try it on a 3x3 example
    for i=1:n_scan_params
        rep = prod( scan_params.lens(1:i-1) );
        cyc = prod( scan_params.lens(i+1:end) );
        % create rep x cyc matrix, then reshape columnwise into vector
        scan_list(i,:) = reshape( repmat(scan_params.vals{i}, rep, cyc), 1, n_runs );
    end
end
