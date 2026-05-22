function [ d, err_train, err_test] = train_test_rc_NRMSE (x, targets, trainsize, reg_term)
    

    %split states (init, train, buffer, test)
    d.x_train = x(:, 1 + trainsize.init : trainsize.init + trainsize.train); %Nx10e3
    d.x_test = x(:, 1 + trainsize.init + trainsize.train + trainsize.buffer : trainsize.init + trainsize.train + trainsize.buffer + trainsize.test);
    d.targets_train = targets(1 + trainsize.init : trainsize.init + trainsize.train);
    d.targets_test =  targets(1 + trainsize.init + trainsize.train + trainsize.buffer : trainsize.init + trainsize.train + trainsize.buffer + trainsize.test);

    %% train
%     X = d.x(:, p.n_warmup+1:p.n_inputs);
%     D = d.d(p.n_warmup+1:p.n_inputs);
    X = d.x_train; 
    D=d.targets_train;
    R = X*X' + reg_term*eye(size(X,1));
    P = X * D';
    d.w = P' * pinv(R);    
    y  = d.w * X;
    num = mean((y - D).^2);
    den = mean((D - mean(D)).^2);
    err_train = num/den;

    X = d.x_test; 
    D=d.targets_test;
    y  = d.w * X; % * p.y_amp; %this  p.y_amp comes from the eval_rc.m and I don't know why do we need it (maybe analog)
    num = mean((y - D).^2);
    den = mean((D - mean(D)).^2);
    err_test = num/den;

    d.out_test = y;

   d.idx_err = find(y ~= D);

        
end



