function [ hab, pressure] = somatoria_case(input, coord, z_input)
%% 3. Pres�o complexa

%% 4. Simula��o da press�o
% Mic 1
    pressure.pa = sum_pressure2(input.freq, input.c0, input.rho0,...
        z_input, coord.mic1, coord.sph, input.A);
% Mic 2 (PP e PU)
    pressure.pb = sum_pressure2(input.freq, input.c0, input.rho0,...
        z_input,  coord.mic2, coord.sph, input.A);
%% 5. Estimativas da imped�ncia de superf�cie
   
hab = pressure.pb./ pressure.pa; % FT entre os microfones


