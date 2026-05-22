function [ p ] = def_p (p)
p.n_neurons = 50;
% p.bias_node    = 0; 

%exp2fpga:
p.smp_dly1     = 62;%32-3;           % sampling delay for ADC 1
p.smp_dly2     = p.smp_dly1 + 2; % sampling delay for ADC 2
p.trig_level   = 250;             % min signal level required to start acquiring reservoir states
p.amp_nrn1     = 5;              % amplification of neurons in FPGA
p.amp_nrn2     = 5;              % amplification of weighted nodes in FPGA
%fpga2exp:
p.n_inputs     = 8000; %max is 8192
p.amp_dac      = 0;          % it was 0. I set 6 for debug
p.wts_dly      = p.smp_dly2 + 5; %
%fpga2PCI
max_sampled_data = p.n_neurons*p.n_inputs;
p.max_sampled_data = ceil(max_sampled_data/ 2^10); % 250e3 --> 250880
% p.max_sampled_data = 1; %WARNING cnt never reach this value
%xilldemo:
    switch p.fpga_data_mode %fake switches {0-x, 1-xy, 4-xw, 7-xwy}
        case 'x', p.fake_sw_b = 0; ;
        case 'xy', p.fake_sw_b = 1; ;
        case 'xw', p.fake_sw_b = 4; ;
        case 'xwy', p.fake_sw_b = 7; ;
    end

%fmc151
p.i_delay_clk = 0;p.i_delay_b = 30;p.i_delay_a = 30;  
p.idelay = p.i_delay_clk*2^10 + p.i_delay_b*2^5 + p.i_delay_a;

end