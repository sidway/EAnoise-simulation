function [ hab, pressure] = somatoria_case(input, coord, z_input)
%% 3. Presão complexa

%% 4. Simulação da pressão
% Mic 1
    pressure.pa = sum_pressure2(input.freq, input.c0, input.rho0,...
        z_input, coord.mic1, coord.sph, input.A);
% Mic 2 (PP e PU)
    pressure.pb = sum_pressure2(input.freq, input.c0, input.rho0,...
        z_input,  coord.mic2, coord.sph, input.A);
%% 5. Estimativas da impedância de superfície
   
hab = pressure.pb./ pressure.pa; % FT entre os microfones


