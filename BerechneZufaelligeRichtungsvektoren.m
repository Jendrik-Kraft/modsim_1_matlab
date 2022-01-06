function [u_x, u_y, u_z] = BerechneZufaelligeRichtungsvektoren(n, m, Schnittpunkt, groesse)
    %% Winkel Berechnung der Photonen
    groesse = groesse - 0.000001; % NOTWENDIG FÜR RUNDUNGSFEHLER
    error=0;
    
    %TODO SONDERFALL >1 WERT == 5 (ECKE/KANTE Getroffen)
    
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
    
    
    %% Bestimmen der richtigen Drehmatrix abhängig von der getroffenen Wand
    if abs(Schnittpunkt(1)) > groesse
        if Schnittpunkt(1) >= groesse
            %Wenn die Wand bei x = groesse getroffen wurde muss um die y-Achse
            %gedreht werden, weil diese Wand parallel zur y-Achse liegt
            drehmatrix = BerechneDrehmatrix(-pi/2,2);
        else
            drehmatrix = BerechneDrehmatrix(pi/2,2);
        end
    elseif abs(Schnittpunkt(2)) > groesse
        if Schnittpunkt(2) >= groesse
            drehmatrix = BerechneDrehmatrix(pi/2,1);
        else
            drehmatrix = BerechneDrehmatrix(-pi/2,1);
        end
    elseif abs(Schnittpunkt(3)) > groesse
        if Schnittpunkt(3) >= groesse
            drehmatrix = BerechneDrehmatrix(pi,1);
        else
            % Drehung um 360 grad entspricht keiner Drehung - 
            % weil  lambertstarhler sowieso nach oben strahlt
            drehmatrix = BerechneDrehmatrix(2*pi,1); 
        end
    elseif Schnittpunkt(1) == 0 && Schnittpunkt(2) == 0 && Schnittpunkt(3) == 0
        drehmatrix = BerechneDrehmatrix(2*pi,1); 
    else error = error+1 % Passiert hoffentlich nie :)
    end

    %% Drehen des Richtungsvektors mit der bestimmten Drehmatrix
    i=1:n;
    gewuerfelte_richtung=[u_x,u_y,u_z]';
    richtungsvektor = drehmatrix*gewuerfelte_richtung(:,i);
    u_x=richtungsvektor(1,:)';
    u_y=richtungsvektor(2,:)';
    u_z=richtungsvektor(3,:)';
    
%     %% Drehen der Vektoren um die angegebenen Winkel a und b
%     drehmatrix=[cos(a)*cos(b),-sin(b),sin(a)*cos(b);
%                 cos(a)*sin(b),cos(b),sin(a)*cos(b) ;
%                 -sin(a)      ,0     ,cos(a)        ;];
%     i=1:n;
%     gewuerfelte_richtung=[u_x,u_y,u_z]';
%     matrix = drehmatrix*gewuerfelte_richtung(:,i);
%     u_x=matrix(1,:)';
%     u_y=matrix(2,:)';
%     u_z=matrix(3,:)';
end
