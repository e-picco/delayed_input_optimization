%main code
%RIDGE regression
%Scan hyper-parameters

clearvars -except obj_opt_att obj_hameg obj_fpga
addpath(genpath('.'));

n_repeats = 1; %how many exp you repeat

p.fpga_data_mode='x'; %'x': nrns, 'xy' nrns & outs, 'xw' nrns & weighted nrns, 'xwy' nrns & weighted nrns & outs   
p = def_p(p);
send_p(p); %set fpga params 
% reset_p_0(p); %reset fpga params to 0

seed_mask=42;
% seed_gauss=43;
seed_data=44;
trainsize.init=500;
trainsize.train=3500;
trainsize.buffer=500;
trainsize.test=3500;
% G1 = 1.8;    %NARMA10   [Jaurige2021]
% bias=0.4;    %NARMA10   [Jaurige2021]
% G1 = 1;    %Mackey-Glass   [Jaurige2021]
% bias=0;    %Mackey-Glass   [Jaurige2021]
G1 = 0.03;   %LORENZ   [Jaurige2021]
bias = 0.85; %LORENZ   [Jaurige2021]
% bias=0.25;   %NARMA10   
alfa = 2; 
reg_term=5e-6;logspace(-5,1,1e2);
p.fpga_u_amp   = 0.1; % ??

%hp - NARMA10 scan [Jaurige2021]
hp.G2_scan=linspace(0,3,20);
hp.dly_scan=0:1:20;
hp.mzb_vals = 3.1;%3.1;2:0.1:4;
% NARMA10 N=50 inp 0.5 - mzb 3.1 - fdb 1.8 (3380 scanned) 

%dataset 
% [inputs, targets] = gen_chan_data(K, seed_data); %channel eq
[inputs, targets] = gen_NARMA_data(p.n_inputs + max(hp.dly_scan) + 1, seed_data); %NARMA10
% [inputs, targets] = gen_MG_data(p.n_inputs + max(hp.dly_scan) + 1, seed_data); inputs=inputs'; targets=targets';%MACKEY_GLASS
% [inputs, targets] = gen_LORENZ_data(p.n_inputs + max(hp.dly_scan) + 1); %LORENZ


[scan_params, scan_list, n_runs] = def_scan_params(hp);

%masks [0,1]
rng(seed_mask)
mask_1 = rand(1,p.n_neurons); 

% rng(seed_mask+1)
% mask_2 = rand(1,p.n_neurons); 

% set attenuator
%opt_att_set_att('Agilent', obj_optatt, 1, hp.fdb);
SetAttenuationJDSHA9(obj_opt_att,alfa,0);

for i_repeat = 1:n_repeats
    for i_run=1:n_runs
        tic

        hp = set_cur_params_to_devices(i_run, n_runs, hp, scan_params, scan_list, obj_opt_att, obj_hameg ); % set HP values of current run to device
        G2 = hp.G2;
        dly = hp.dly;
        
        %delayed input
%         J = G1*mask_1'*inputs(1:p.n_inputs) + G2*mask_2'*inputs(dly+1:dly+p.n_inputs) + bias; %Nx8000
        d.J = G1*inputs(1:p.n_inputs) + G2*inputs(dly+1:dly+p.n_inputs) + bias; %1x8000

        %train
%         d = fpga_update(p, hp, d, 'train'); % write data (inputs, mask) to the FPGA
        fpga_send_data(d.J, mask_1, p.fpga_u_amp); %R: train data (input, masks, hp.inp) uploaded on fpga
        [d.x, d.y, d.xw] = fpga_run(p);
        [d, r.err_train(i_run), r.err_test(i_run)] = train_eval_rc_NRMSE(d.x, targets, trainsize, reg_term); % train reservoir computer
        fprintf('Train error: %.2e. Test error: %.2e. \n', r.err_train(i_run), r.err_test(i_run));

        if n_runs>1
            subplot(2,2,1)
            pause(0.0001)
            plot(1:i_run, r.err_train(1:i_run),'x-b', 1:i_run, r.err_test(1:i_run), 'x-r')
            legend('train', 'test')
            grid on
        end
        
        h2=subplot(2,2,2);
        cla(h2)
%         clf
        hold on
        plot(d.targets_test(101:130),'b')
        plot(d.out_test(101:130),'r')
        plot(d.out_test(d.idx_err(101:130)), 'bx')

        %     toc
    end

    r.err_test_all(i_run, i_repeat) = r.err_test(i_run);
end

subplot(2,2,3)
err_test_plot = reshape(r.err_test, length(hp.G2_scan), length(hp.dly_scan));
% imagesc(hp.dly_scan, hp.G2_scan,err_test_plot)
imagesc(hp.G2_scan,hp.dly_scan, flip(rot90(err_test_plot),1))
set(gca,'YDir','normal');
xlabel('G2')
ylabel('dly')
colorbar
c.Label.String = 'NRMSE';


results_sorted = sortrows([scan_list ; r.err_test]', 4);

save(['res_LORENZ_dly_inp_hpscan_' num2str(p.n_neurons) '.mat'], 'results_sorted','G1','alfa', 'bias', 'reg_term', 'trainsize', 'p');

