addpath('E:\Estudos\Pesquisa\Recursos\Organ_codes\processing-insitu-EAimpedance')
% Angulo escolhido para ver plots
idx = 50/5 + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ref: In situ measurements of surface  impedance and absorption coefficients
%         of porous materials using two microphones and ambient noise.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Entradas
    % Entradas gerais: Frequência de análise, condições climática,
    % caracteristicas do ar;
    [input, f] =  entradas_tcc;
    
    % Resistividade ao fluxo
    material.resistivity =  12500; % kg²/m³

    % Espessura da amostra
    material.thickness = 0.05;  % meters [m]

    % Distancia da fonte até amostra
    coord.r = 2.5;

    % Coordenadas do receptores         
    coord.mic1 = [0.00 0.0 0.025]; % microfone 1
    coord.mic2 = [0.00 0.0 0.010]; % microfone 2

    % Parametros da estimativa da impedância (relacionado a coordenadas)
    coord.l = 15/1000; % Distancia entre microfones
    coord.d = 10/1000; % Distancia até a amsotra

    % Vetor de angulos de incidêcia
    coord.thetas = deg2rad(0:5:78); 

    % Coordenadas y e z da fonte 
    coord.sph(2,:) = sin(coord.thetas)*coord.r;
    coord.sph(3,:) = cos(coord.thetas)*coord.r;
 
% Impedancia de superficie por incidencia difusa (OTSURO)
    [zs.field,~] =  material_reference2(input.freq_sim, 50e-3, 12500,0.99, 1, 1,2,input);
    [~, alpha_fit] = reflection_and_absorption_coefficient(zs.field,input.z0,0);

%     [zs.field, oblique.zs_theta] = oblique_aniso_impedance ...
%         (material.thickness, material.resistivity...
%     , 0.6, input.rho0, input.c0, coord.thetas,input.freq_sim);
    % 3. Pressão Complexa Aleatória (salve para cada simulação)
    % Não altera nada nesta simulação
    % Limites Inferior e superior
    A = complex_pressure(20, 120, 2*pi, coord.thetas);

    % 4. Simulação da pressão

    %Inicializa vetor de pressão
    pressure.pa = zeros(length(input.freq_sim),length(coord.thetas) );
    pressure.pb = zeros(length(input.freq_sim),length(coord.thetas) );
    surf_impedance = zs.field;
    
    for k = 1:length(coord.thetas)
        fonte = coord.sph(:,k);
        % Mic 1
        pressure.pa(:,k) = sum_pressure2(input.freq_sim,input.c0,input.rho0,...
            surf_impedance, coord.mic1, fonte, A(k));
        % Mic 2 
        pressure.pb(:,k) = sum_pressure2(input.freq_sim,input.c0,input.rho0,...
            surf_impedance, coord.mic2, fonte, A(k));
    end
    
    clear fonte surf_impedance

    % 5. Estimativas da impedância de superfície
    % A) zs.z_pw(f,\theta). Estimativa assumindo ondas planas, dependencia angular

    % Inicializa vetor de impedâncias
    zs.z_pw =   zeros(length(input.freq_sim),length(coord.thetas) );
    zs.z_avg =  zeros(length(input.freq_sim),length(coord.thetas) );
    alpha.pw =  zeros(length(input.freq_sim),length(coord.thetas) );
    alpha.avg = zeros(length(input.freq_sim),length(coord.thetas) );

    % Loop de angulos
    for mn = 1:length(coord.thetas)

        angulo = coord.thetas(mn);

        % Função transferencia (pb/pa) em função do angulo de incidência
        hab = pressure.pb(:,mn)./pressure.pa(:,mn);

        % Calculo da componente obliqua de Z_pw0 (ref: Zn(\theta,f)
        [zs.z_pw(:,mn), ~, alpha.pw_theta(:,mn)] = oblique_pp_estimation(hab, input.k0,  coord.l,...
            coord.d, angulo,input.rho0, input.c0);

        % Calculo da componente obliqua de Z_avg (ref: z_eacom)
        [zs.z_avg(:,mn),~, alpha.avg_theta(:,mn)] = average_pp_estimation(hab, input.k0,  coord.l,...
            coord.d, angulo,input.rho0, input.c0);

    end

    clear angulo hab
    
    % Plot
    an = 4;
  %
%     figure(1)
%     semilogx(input.freq_sim, real(zs.z_pw(:,an)),'b','linew', 2); hold on
%     semilogx(input.freq_sim, real(oblique.zs_theta(:,an)*input.rho0*input.c0),'--r','linew', 2)
%     semilogx(input.freq_sim, real(zs.z_avg(:,an)),'--k','linew', 3)
% 
%     semilogx(input.freq_sim, imag(zs.z_pw(:,an)),'b','linew', 2); hold on
%     semilogx(input.freq_sim, imag(oblique.zs_theta(:,an)*input.rho0*input.c0),'--r','linew', 2)
%     semilogx(input.freq_sim, imag(zs.z_avg(:,an)),'--k','linew', 3)
%     legend('Z_{pw}', 'Zs(f,\theta)', 'Z_{avg}','location', 'best')
%     % ylim([-10 10])
%     xlim([100 10000])
%
    % Field of incidency
    % Calculando a impedância de campo pela formula de paris
    ro = input.rho0; co = input.c0;
    % Formula de paris para componente de average
    zs.paris_avg = paris_formula( zs.z_avg , coord.thetas) ;
    R = (zs.paris_avg - (ro*co) )./(zs.paris_avg + (ro*co));
    alpha.avg = 1 - abs(R).^2; clear R
    % Formula de paris para componente de onda plana
    zs.paris_pw = paris_formula( zs.z_pw , coord.thetas) ;
    R = (zs.paris_pw - (ro*co) )./(zs.paris_pw + (ro*co));
    alpha.pw = 1 - abs(R).^2; clear R
    %% Plot
    filename = 'sim2-imp';
    fig = figure('position', [50 50 800 600]);
    plot_impedance(input.freq_sim, zs.field, f ,'-',[0.0 0.0 0.0]); hold on
    plot_impedance(input.freq_sim, zs.paris_pw, f ,'--',[0.7 0.0 0.0]); hold on
    plot_impedance(input.freq_sim, zs.paris_avg, f ,'--',[0.0 0.0 0.7]); hold on
    
    legend('Referência', 'Z_{DF}', 'Z_{avgDF}'  ,'location', 'best')
     save_as_pdf (filename, fig)
    savefig(filename)

%% Absorption
filename = 'sim2-abs';
fig = figure('position', [50 50 800 600]);
plot_absorption(input.freq_sim, alpha_fit, ...
    f ,'-',[0.1 0.1 0.1]); hold on
plot_absorption(input.freq_sim, alpha.pw, ...
    f ,'--',[0.7 0.1 0.1]); hold on
plot_absorption(input.freq_sim, alpha.avg, ...
    f ,'--',[0.0 0.1 0.7]); hold on

    legend('Referência', 'Z_{DF}', 'Z_{avg}' ,'location', 'best')
    ylim([0 1.20])
    xlim([100 10000])
    xlabel('Frequência [Hz]'); ylabel('\alpha [-]')
    set(gca,'fontsize', 16)
    save_as_pdf (filename, fig)
    savefig(filename)

