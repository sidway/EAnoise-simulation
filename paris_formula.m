function z_paris = paris_formula( z , theta_vector) 
% Discrete Paris formula for surface impedance (used for difuse field or another 
% incident angle integration )
% Input: z = Matrix of normal surface impedance at oblique incidence
        %theta_vector = matrix of oblique incidences
% Output 
        %z_paris = The average field/difuse surface impedance
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Weitgh function
m = ones(1,length(theta_vector));
m(1) = 1; m(end) = 1;

% Divident of the equation
lower_part = sum(sin(theta_vector).*m.*cos(theta_vector));

% Admitance
admit = 1./z;

% Upper part of the equation
uper_part = sum(admit.*m.*sin(theta_vector).*cos(theta_vector),2);

% Paris calculation of the admitance
b_paris = uper_part/lower_part;

% Converting to impedance
z_paris = 1./b_paris;


