function [u_x, u_y, u_z] = BerechneKoordinatenform(m,n)
    %% Winkel Berechnung der Photonen
    u = rand(n,1);  % Gleichverteilte Zufallsvariable
    cos_theta = nthroot(u,m+1); 
    sin_theta = sqrt(1-cos_theta.^2);
    phi = 2*pi()*rand(n,1);
    cos_phi = cos(phi);
    sin_phi = sin(phi);
    
    %% Vektor Berechnung der Photonen
    u_x = sin_theta .* cos_phi;
    u_y = sin_theta .* sin_phi;
    u_z = cos_theta;
end
