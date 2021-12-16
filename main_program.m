% Autor: Jenny Kuhn und Jendrik Kraft 
% Modul: Modellierung und Simulation 1
% Thema: Lichtausbreitung in Räumen: Skizzen zur Monte-Carlo-Simulation

clc;
clear;
close all;
m = 7;  % Lambert Parameter
n = 7;  % Anzahl der gewürfelten Photonen
u = rand(n,1);  % Gleichverteilte Zufallsvariable
p = 0.7; %reflektions_wahrscheinlichkeit
Lichtquelle = [0,0,0];
groesse = 5;
% Lambertstrahler_Startpunkt
% Abstrahlrichtung

%TODO: Potenzielles Problem: Unendlich viele Schnittpunkte bei
%abstrahlwinkel 0% oder 180%
%% Drehung des Lambertstrahlers

%% Berechnung der zufälligen Richtungsvektoren der Photonen
% TODO warum schickt ein Startpunkt von 5 und -5 in die gleiche Richtung?
[u_x, u_y, u_z] = BerechneZufaelligeRichtungsvektoren(n,m,Lichtquelle,groesse);


%% Wand Matrizen Definition
%             Decke  Boden   Vorne   Hinten  Links  Rechts
P1 = groesse*[0,0,1; 0,0,-1; 1,0,0; -1,0,1; 0,1,0; 1,-1,1;];
P2 = groesse*[1,0,1; 1,0,-1; 1,0,1; -1,0,0; 1,1,1; 1,-1,0;];
P3 = groesse*[0,1,1; 0,1,-1; 1,1,1; -1,1,1; 1,1,0; 0,-1,1;];

[A,B,C,D]=BerechneKoordinatenform(P1,P2,P3);

%% Berechnen der Schnittpunkte mit Wand
stuetz_v = [0 0 0];       % letzter Schnittpunkt
richtungs_v = [u_x u_y u_z];        % umrechnung vom Winkel?
% TODO Bschreiben was die Funktion tut..
richtiger_Schnittpunkt = BerechneSchnittpunkt(stuetz_v, richtungs_v, A, B, C, D, n, groesse);
alle_schnittpunkte = richtiger_Schnittpunkt;
% Zum anhängen: alle_schnittpunkte =
% [alle_schnittpunkte;richtiger_Schnittpunkt];
%% Plotten des Photonenwegs
X = [zeros(n,1) richtiger_Schnittpunkt(:,1)] ;
Y = [zeros(n,1) richtiger_Schnittpunkt(:,2)] ;
Z = [zeros(n,1) richtiger_Schnittpunkt(:,3)] ;




%% Überleben oder verschwinden des Photons ermitteln
k = 1:1:n;
ueberlebens_matrix = ceil(rand(n,1)-(1-p));
%neue_startpunkte=richtiger_Schnittpunkt(ueberlebens_matrix(k)~=0, :, :);
neue_startpunkte=richtiger_Schnittpunkt;

%% Ausrechnen des nächsten Abstrahlvektors... -> Schleife
u_x= zeros(1,length(neue_startpunkte));
u_y= zeros(1,length(neue_startpunkte));
u_z= zeros(1,length(neue_startpunkte));
naechster_schnittpunkte=zeros(length(n),3);

loops=2;
photonen = n;
while photonen > 0
    loops=loops+1;
    for x=1:n
        if ueberlebens_matrix(x)==1

            [u_x(x),u_y(x),u_z(x)] = BerechneZufaelligeRichtungsvektoren(1,1,neue_startpunkte(x,:),groesse);
            stuetz_v = neue_startpunkte(x,:);
            richtungs_v = [u_x(x) u_y(x) u_z(x)];
            naechster_schnittpunkte(x,:) = BerechneSchnittpunkt(stuetz_v, richtungs_v, A, B, C, D, 1, groesse);


        else
            naechster_schnittpunkte(x,:)=nan(1,3);
            photonen = photonen -1
        end
        X(x,loops) = naechster_schnittpunkte(x,1);
        Y(x,loops) = naechster_schnittpunkte(x,2);
        Z(x,loops) = naechster_schnittpunkte(x,3);
        
    end
    ueberlebens_matrix = ceil(rand(n,1)-(1-p)).*ueberlebens_matrix;
%     k=1:size(neue_startpunkte,1);
%     ueberlebens_matrix = ceil(rand(size(neue_startpunkte,1),1)-(1-p));
    neue_startpunkte=naechster_schnittpunkte;
end
figure(1)

plot3(X(:,:)',Y(:,:)',Z(:,:)')
hold on
plot3(X(:,:)',Y(:,:)',Z(:,:)')%,'.')
xlim([-5,5])
ylim([-5,5])
zlim([-5,5])
hold on
grid on

%% Drehmatrix
%Neues auswürfeln von x,y,z...
% gewuerfelte_richtung=[u_x,u_y,u_z];
% a=pi/2;
% drehmatrix_x=[1,      0,       0;
%               0, cos(a), -sin(a);
%               0, sin(a), cos(a)];
% i=1:n;
% matrix = drehmatrix_x*gewuerfelte_richtung(i,:)';
% u_x=matrix(1,:)';
% u_y=matrix(2,:)';
% u_z=matrix(3,:)';

