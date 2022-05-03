%% Criando meia esfera acima de um plano (sem incidencia rasantes)
function [com_sph] = mid_sphere(r, n)
    % raio da esfera
%     r = 500;
    % Gera a esfera equivalentemente distribuida
      [vMat, ~] = spheretri(n);
% Pega pontos cujo a incidencia seja no m�ximo 78�
    % Incializa contador
    h = 1;
    % Varre de 1 at� o tamanho do vetor de coordenadas 
    for k = 1:length(vMat) 
        % Seleciona os pontos acima de um determinado treshold
        if vMat(k,3) > 0.2 % (cos(78�) = 0,2079)
            % Escala pelo raio 
            com_sph(h,:) = vMat(k,:)*r;
            h = h+1;
        end
    end

    return
end

