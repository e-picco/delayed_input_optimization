function [ d ] = fpga_update (p, hp, d, stage)
    % Generate inputs for batch approache, load data to FPGA
    % Written by Enrico Picco, Feb 2022

    switch stage
        case 'train', mode = 'same';
        case 'test',  mode = 'same';
    end

    % update inputs and mask, when needed
    if strcmp(mode, 'same') %&& ( i==1 || i==p.n_iter_train+1)

       

        fpga_send_data(d.u, d.wi, hp.inp); %R: train data (input, masks, hp.inp) uploaded on fpga

                %debug
        switch stage
            case 'train', d.pat_train=d.u; d.mask_train=d.wi*hp.inp; d.masked_inp_tr=d.pat_train'*d.mask_train;
            case 'test',  d.pat_test=d.u;  d.mask_test=d.wi*hp.inp;  d.masked_inp_te=d.pat_test'*d.mask_test;
        end

    elseif strcmp(mode, 'new')
        seed = i;
        [d.u, d.d] = gen_chan_data(p.n_inputs, seed, p.fpga_u_amp); %R: test dataset (input,targets) generated
        fpga_send_data(d.u, d.wi, hp.inp); %R: test data (input, masks, hp.inp) uploaded on fpga
    end

%     % update weights if required by the training option
%     if ~strcmp(p.train, 'ridge') && strcmp(stage, 'train')
% %         d.w(:, i)=0*d.w(:, i); %DEBUG
% %         d.w(1, i)=0.5; %DEBUG
% %         d.w(20, i)=0.2; %DEBUG
% %         d.w(30, i)=-0.2; %DEBUG
% %         
%         fpga_update_weights(obj, d.w(:, i));
% %         
% %         w_MZ2 = f3(d.w(:, i));
% %         fpga_update_weights(obj, w_MZ2);
%     end
end