%% Componente obliqua da imped�ncia m�dia Z_avg (ou Z_EAcom)
% Assume ondas planas
% Entradas:
            %hab = Fun��o transferencia entre 2 mics (pb/pa)
            %k = numero de onda
            %l = espa�amento entre microfones
            %d = distancia at� a amostra
            %theta = angulo de incidencia da onda
            %ro = densidade do ar
            %co = velocidade do som no ar
% Sa�das:
            %z_avg = Componente obliqua da imped�ncia m�dia Z_avg
            %R = coeficiente de reflex�o 
            %alpha = coeficiente de absor��o
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Escrito por Sidney Volney C�ndido
% Refer�ncia: In situ measurements of surface  impedance and absorption 
% coefficients of porous materials using two microphones and ambient noise.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function [z_avg R, alpha] = average_pp_estimation(hab,k, l, d, theta,ro,co)

z_avg = ro*co*((hab.*(1-exp(2*1i.*k*(l+d)))-exp(1i.*k*l).*(1-exp(2i.*k*d)))./...
(hab.*(1+exp(2*1i.*k*(l+d)))-exp(1i.*k*l).*(1+exp(2i.*k*d))));

R = (z_avg*cos(theta) - 1)./(z_avg*cos(theta) + 1);

alpha = 1 - abs(R).^2;