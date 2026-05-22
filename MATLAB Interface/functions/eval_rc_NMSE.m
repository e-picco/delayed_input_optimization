
function [ d, err] = eval_rc_NMSE (p, d)

    y  = d.w * d.x; % * p.y_amp; 
    Y = y(p.n_warmup+1:p.n_inputs);
    D = d.d(p.n_warmup+1:p.n_inputs);
    
    num = mean((Y - D).^2);
    den = mean((D - mean(D)).^2);
    err = num/den;

    d.idx_err = find(y(p.n_warmup+1:p.n_inputs) ~= d.d(p.n_warmup+1:p.n_inputs));
    d.D=D;
    d.Y=Y;
%     d.y=y;

    
end