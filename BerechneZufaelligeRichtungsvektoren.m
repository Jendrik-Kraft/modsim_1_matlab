function [u_x, u_y, u_z] = BerechneZufaelligeRichtungsvektoren(n, m, a, b)
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
    
    %% Drehen der Vektoren um die angegebenen Winkel a und b
    drehmatrix=[cos(a)*cos(b),-sin(b),sin(a)*cos(b);
                cos(a)*sin(b),cos(b),sin(a)*cos(b) ;
                -sin(a)      ,0     ,cos(a)        ;];
    i=1:n;
    gewuerfelte_richtung=[u_x,u_y,u_z];
    matrix = drehmatrix*gewuerfelte_richtung(i,:)';
    u_x=matrix(1,:)';
    u_y=matrix(2,:)';
    u_z=matrix(3,:)';
end
