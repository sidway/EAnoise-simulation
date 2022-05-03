%% Calculo da press�o sonora sob amostra localmente reativa adaptada para campo difuso
function pressure = sum_pressure2(frequencia, c0, rho0, zs, coord_mic, com_sph, A)
    porous.Z = zs; %%% imped�ncia de entrada
     %%% Vetor de frequ�ncia
    vel_air = c0; %%% Velocidade do som
    den_air = rho0; %%% Desindade do ar
    
    % Coordenadas do microfones no plano xy
    cx = coord_mic(1);
    cy = coord_mic(2);
    
     % Posica��o z da fonte
    hs = com_sph(3,:);
     % Posi��o z do receptor
    za = coord_mic(3);
    % Distancia horizontal da fonte
    r = sqrt((com_sph(1,:) - cx).^2 + (com_sph(2,:) - cy).^2);
    % Distancia da fonte real e imagem at� o sensor
    R1=sqrt((r.^2)+((hs-za).^2));
    R2=sqrt((r.^2)+((hs+za).^2));
     
    % Admitancia
    beta = (den_air*vel_air) ./ porous.Z;
    % Numero de onda no ar
    k0 = 2 * pi * frequencia/vel_air;
    
    % Integrando (com amplitude complexa)
    int_pa=@(q)(A.*((exp((-q.*k0).*beta)).*...
        exp(-1i*k0.*(sqrt((r.^2)+(hs+za-1i*q).^2))))./...
        (sqrt((r.^2)+(hs+za-1i*q).^2)));
   
    % Integral
    Iqa=-(2*k0.*beta).*integral(int_pa,0,20,'ArrayValued',true);
    % Somat�rio de todos os termos
    pressure=sum((A.*(exp(-1i*k0*R1)/R1)+...
        A.*(exp(-1i*k0*R2)/R2)+Iqa),2);

