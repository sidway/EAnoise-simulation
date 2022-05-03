%% Seção Dois Impedância de superficie dependente do campo
function [zs_field,zs_normal]=  material_reference2(freq, thickness, resitivity, por, ks, s,model,EG)
%% Comparando Miki field com os efeitos anisotropicos
% Entradas Gerais
    ro = 1.2; co = 343;
    w = 2*pi*freq;
    EG.t = thickness;
    
    if model == 1
        % Miki Model (incidencia normal)
        [kc, zc, ~, ~] = miki_gen(resitivity, freq, ro, co, thickness);
        
    else 
        % Allard model
        [zs_normal, zc, kc]=Z_Allard2(w,ro,thickness,resitivity,por,ks,s);
       
    end
theta_vector = deg2rad(0:78);
%% MIKI AVG
zs_field = var_sur_imp(zc, kc, theta_vector,EG.t,freq);
EG.k0 = w/co;
end