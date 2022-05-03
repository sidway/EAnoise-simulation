%% Impedância de superfície normal por incidência obliqua
% Assume ondas planas
% Entradas:
            %hab = Função transferencia entre 2 mics (pb/pa)
            %k = numero de onda
            %l = espaçamento entre microfones
            %d = distancia até a amostra
            %theta = angulo de incidencia da onda
            %ro = densidade do ar
            %co = velocidade do som no ar
% Saídas:
            %z_pw = Estimativa da impedância de superfie normal
            %R = coeficiente de reflexão 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Escrito por Sidney Volney Cândido
% Referência: In situ measurements of surface  impedance and absorption 
% coefficients of porous materials using two microphones and ambient noise.         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
function [z_pw, R, alpha] = oblique_pp_estimation(hab,k, l, d, theta,ro,co)

z_pw  = (ro*co/cos(theta))*(hab.*(1-exp(2*1i.*k*(l+d)*cos(theta)))-exp(1i.*k*l*cos(theta)).*(1-exp(2i.*k*d*cos(theta))))./...
(hab.*(1+exp(2*1i.*k*(l+d)*cos(theta)))-exp(1i.*k*l*cos(theta)).*(1+exp(2i.*k*d*cos(theta))));

R = (z_pw*cos(theta) - (ro*co) )./(z_pw*cos(theta) + (ro*co));

alpha = 1 - abs(R).^2;
