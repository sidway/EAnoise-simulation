close all; clear
% Espessura da amostra
dim = 50e-3;
addpath('E:\Estudos\Pesquisa\Recursos\Organ_codes\processing-insitu-EAimpedance')
% Configurações de plot e vetores de frequencia, numero de onda
[input, f] =  entradas_tcc;
f.fmax = 10000;
f.fmin = 100;
input.freq = input.freq_sim;
input.k0 = 2*pi*input.freq/input.co;

% ProPRIEDADES DO AR
To=18; %[Celsius]
Po=101100; % [Pa]
HR=71;  %[por cento]

% Calculo da velocidade do Som e densidade do ar
[input.rho,input.co,~,~,~,~,~]=propair_panneton(To,Po,HR); clear To Po HR
    
% Experimento
% Distancia entre microfones, intriseco do aparato
l = 15/1000;
% distancia do mic 1 até a amostra 
d = 10/1000;
% Distancia da fonte até o centro da amostra
coord.r =2.5;           

coord.mic1 = [0 0 l+d]; % Coordenada do mic 1
coord.mic2 = [0 0 d];   % Coordenada do mic 2

% Estimativa da impedancia de superficie por incidencia difusa (OTSURO)
[zs_field,~, zs_normal] =  material_reference2(input.freq_sim, dim, 12500,0.99, 1, 1,2,input);
% Difuse
[~, alpha_fit] = reflection_and_absorption_coefficient(zs_field,input.z0,0);
% Normal
[~, alpha_n] = reflection_and_absorption_coefficient(zs_normal,input.z0,0);

plot_absorption(input.freq, alpha_n, ...
    f ,'-',[0.4 1 0.1]); hold on
plot_absorption(input.freq, alpha_fit, ...
    f ,'--',[0 0 0]); hold on


%% OTSURO (campo difuso)
% Numero de campos
n = 50; 
% Posicionamento das fontes
[coord.sph] = mid_sphere(coord.r,302)';
% inicialização de vetores
ot.alpha_avg = zeros(length(input.freq),n);
ot.hab_avg = zeros(length(input.freq),n);
ot.z_avg = zeros(length(input.freq),n);

%Loop de campos
    for i = 1:n
    % Geração da amplitude complexa
     input.A = complex_pressure(20, 120, 2*pi, coord.sph(3,:));
    %% Simulação do campo de pressão sob amostra localmente reativa,
    % adaptado para campo difuso.
    [ ot.hab_avg(:,i), pressure] = somatoria_case(input, coord, zs_field);
    end
% Estimativa z_avg     
[ot.z_avg] = ra_pp_estimation(mean(ot.hab_avg,2),input.k0, l, d,input.rho0,input.c0); 
% Coeficiente de Absorção 
[~, ot.alpha_avg] = reflection_and_absorption_coefficient(ot.z_avg,input.z0,0);    

clear coord
% %%
run('E:\Estudos\Pesquisa\a00 - Dados\simulacao2 - incidencia de campo\estudo_case02.m')
close all
    %% Plot
    figure('position', [200 50 900 600])
    plot_impedance(input.freq_sim, zs.field, f ,'-',[0.0 0.0 0.0]); hold on
    plot_impedance(input.freq_sim, ot.z_avg, f ,'--',[0.7 0.0 0.0]); hold on
    plot_impedance(input.freq_sim, zs.paris_avg, f ,'--',[0.0 0.0 0.7]); hold on
    
    legend('Referência', 'Simulação 3', 'Simulação 2' ,'location', 'best')
    
%% Absorption
figure('position', [50 50 800 600])
plot_absorption(input.freq_sim, alpha_fit, ...
    f ,'-',[0.1 0.1 0.1]); hold on
plot_absorption(input.freq_sim, ot.alpha_avg, ...
    f ,'--',[0.7 0.1 0.1]); hold on
plot_absorption(input.freq_sim, alpha.avg, ...
    f ,'--',[0.0 0.1 0.7]); hold on

  legend('Referência', 'Simulação 3', 'Simulação 2' ,'location', 'best')
