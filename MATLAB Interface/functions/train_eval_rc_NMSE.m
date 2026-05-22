function [ d, err] = train_eval_rc_NMSE (p, hp, d)
    
    %train
    X = d.x(:, p.n_warmup+1:p.n_inputs);
    D = d.d(p.n_warmup+1:p.n_inputs);
    R = X*X' + p.reg_term*eye(size(X,1));
    P = X * D';
    d.w = P' * pinv(R);
    
    %eval
    y  = d.w * d.x; % * p.y_amp;
    Y = y(p.n_warmup+1:p.n_inputs);
    num = mean((Y - D).^2);
    den = mean((D - mean(D)).^2);
    err = num/den;

        
end



