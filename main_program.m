% Autor: Jenny Kuhn und Jendrik Kraft 
% Modul: Modellierung und Simulation 1
% Thema: Lichtausbreitung in Räumen: Skizzen zur Monte-Carlo-Simulation

clc;
clear;
close all;
m = 1;  % Lambert Parameter
n = 1000;  % Anzahl der gewürfelten Photonen
u = rand(n,1);  % Gleichverteilte Zufallsvariable
p = 0.6; %reflektions_wahrscheinlichkeit
% Lambertstrahler_Startpunkt
% Abstrahlrichtung

%% Drehung des Lambertstrahlers

%% Winkel Berechnung der Photonen
cos_theta = nthroot(u,m+1); 
sin_theta = sqrt(1-cos_theta.^2);
phi = 2*pi()*rand(n,1);
cos_phi = cos(phi);
sin_phi = sin(phi);

%% Vektor Berechnung der Photonen
u_x = sin_theta .* cos_phi;
u_y = sin_theta .* sin_phi;
u_z = cos_theta;


%% Wand Matrizen Definition
groesse = 5;
%             Decke  Boden   Vorne   Hinten  Links  Rechts
P1 = groesse*[0,0,1; 0,0,-1; 1,0,0; -1,0,1; 0,1,0; 1,-1,1;];
P2 = groesse*[1,0,1; 1,0,-1; 1,0,1; -1,0,0; 1,1,1; 1,-1,0;];
P3 = groesse*[0,1,1; 0,1,-1; 1,1,1; -1,1,1; 1,1,0; 0,-1,1;];

[A,B,C,D]=BerechneKoordinatenform(P1,P2,P3);
% for n=1:6
%         normal(:,n) = cross(P1(n,:)-P2(n,:), P1(n,:)-P3(n,:));
%         A(n) = normal(1,n);
%         B(n) = normal(2,n);
%         C(n) = normal(3,n);
%         D(n) = -dot(normal(:,n),P1(n,:));
% end



%% Berechnen der Schnittpunkte mit Wand
stuetz_v = [0 0 0];       % letzter Schnittpunkt
richtungs_v = [u_x u_y u_z];        % umrechnung vom Winkel?
% -------------------- Notizen ----------------------------
% g = stuetz_v + t * richtungs_v
% Wand:
% normal(1)*x + normal(2)*y + normal(3)*z = d
% gleichsetzen
% A*(stuetz_v(1)+t*richtungs_v(1))+B*(stuetz_v(2)+t*richtungs_v(2))+C*(stuetz_v(3)+t*richtungs_v(3)) = D
% ---------------------------------------------------------
Schnittpunkt=zeros(n,3,6);
t=zeros(n);
for pz=1:n
    for wand=1:6
        t(pz) = (-A(wand)*stuetz_v(1) - B(wand)*stuetz_v(2) - ...
        C(wand)*stuetz_v(3) - D(wand)) / (A(wand)*richtungs_v(pz,1) + ...
        B(wand)*richtungs_v(pz,2) + C(wand)*richtungs_v(pz,3));
        Schnittpunkt(pz,:,wand) = stuetz_v + t(pz)*richtungs_v(pz,:);
    end
end

%% Ermitteln der zuerst getroffenen Wand
richtiger_Schnittpunkt=zeros(n,3);
for wand=1:6
    %Ermitteln aller Schnittpunkte die alle Koordinaten innerhalb der Raums
    %haben
    photon_nr=find(Schnittpunkt(:,1,wand)<groesse+0.00001 & Schnittpunkt(:,1,wand)>=-groesse-0.00001&...
                             Schnittpunkt(:,2,wand)<groesse+0.00001 & Schnittpunkt(:,2,wand)>=-groesse-0.00001&...
                             Schnittpunkt(:,3,wand)<groesse+0.00001 & Schnittpunkt(:,3,wand)>=-groesse-0.00001);
    %Speichern dieser Schnittpunkte
    %TODO Checken ob schon ein Schnittpunkt für diese photon_nr eingetragen
    %ist, wenn ja, schauen welcher der richtige ist (Winkel? Urpsrungs
    %u_x,u_y,u_z?)
    richtiger_Schnittpunkt(photon_nr,:) = Schnittpunkt(photon_nr,:,wand);
end
%Berechnen
entfernungen = sqrt((Schnittpunkt(:,1,:)-stuetz_v(1)).^2+(Schnittpunkt(:,2,:)-stuetz_v(2)).^2+(Schnittpunkt(:,3,:)-stuetz_v(3)).^2);
%kleinste_entf = min(
%% Überleben oder verschwinden des Photons ermitteln
ueberlebens_matrix = ceil(rand(n,1)-p); % 0 für <= p, 1 für > p

%% Ausrechnen des nächsten Abstrahlvektors... -> Schleife

%% Plotten des Photonenwegs
X = [zeros(n,1,6) Schnittpunkt(:,1,:)] ;
Y = [zeros(n,1,6) Schnittpunkt(:,2,:)] ;
Z = [zeros(n,1,6) Schnittpunkt(:,3,:)] ;

figure(1)
plot3(X(:,:,3)',Y(:,:,3)',Z(:,:,3)')
hold on
plot3(X(:,:,3)',Y(:,:,3)',Z(:,:,3)','.')
hold on
grid on
