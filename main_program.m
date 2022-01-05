% Autor: Jenny Kuhn und Jendrik Kraft 
% Modul: Modellierung und Simulation 1
% Thema: Lichtausbreitung in Räumen: Skizzen zur Monte-Carlo-Simulation

clc;
clear;
close all;
m = 1;  % Lambert Parameter
n = 1000;  % Anzahl der gewürfelten Photonen
u = rand(n,1);  % Gleichverteilte Zufallsvariable
p = 0.1; %reflektions_wahrscheinlichkeit
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
schnittpunkt = BerechneSchnittpunkt(stuetz_v, richtungs_v, A, B, C, D, n, groesse);
alle_schnittpunkte = schnittpunkt;
% Zum anhängen: alle_schnittpunkte =
% [alle_schnittpunkte;Schnittpunkt];
%% Plotten des Photonenwegs
X = [zeros(n,1) schnittpunkt(:,1)] ;
Y = [zeros(n,1) schnittpunkt(:,2)] ;
Z = [zeros(n,1) schnittpunkt(:,3)] ;




%% Überleben oder verschwinden des Photons ermitteln
k = 1:1:n;
ueberlebens_matrix = ceil(rand(n,1)-(1-p));
startpunkte=schnittpunkt;

%% Ausrechnen des nächsten Abstrahlvektors... -> Schleife
u_x= zeros(1,length(startpunkte));
u_y= zeros(1,length(startpunkte));
u_z= zeros(1,length(startpunkte));
naechster_schnittpunkt=zeros(length(n),3);

loops=2;
photonen = n;
while photonen > 0
    loops=loops+1;
    for i=1:n
        if ueberlebens_matrix(i)==1

            [u_x(i),u_y(i),u_z(i)] = BerechneZufaelligeRichtungsvektoren(1,1,startpunkte(i,:),groesse);
            stuetz_v = startpunkte(i,:);
            richtungs_v = [u_x(i) u_y(i) u_z(i)];
            naechster_schnittpunkt(i,:) = BerechneSchnittpunkt(stuetz_v, richtungs_v, A, B, C, D, 1, groesse);


        else
            naechster_schnittpunkt(i,:)=nan(1,3);
            photonen = photonen -1;
        end
        X(i,loops) = naechster_schnittpunkt(i,1);
        Y(i,loops) = naechster_schnittpunkt(i,2);
        Z(i,loops) = naechster_schnittpunkt(i,3);
        
    end
    ueberlebens_matrix = ceil(rand(n,1)-(1-p)).*ueberlebens_matrix;
    startpunkte=naechster_schnittpunkt;
    alle_schnittpunkte =[alle_schnittpunkte;rmmissing(naechster_schnittpunkt)];
end

%% Zeichnen der heatmap für jede Wand

oben = alle_schnittpunkte(find(alle_schnittpunkte(:,3)>=groesse-0.000001),:);
unten = alle_schnittpunkte(find(alle_schnittpunkte(:,3)<=-groesse+0.000001),:);

links = alle_schnittpunkte(find(alle_schnittpunkte(:,2)>=groesse-0.000001),:);
rechts = alle_schnittpunkte(find(alle_schnittpunkte(:,2)<=-groesse+0.000001),:);

vorne = alle_schnittpunkte(find(alle_schnittpunkte(:,1)>=groesse-0.000001),:);
hinten = alle_schnittpunkte(find(alle_schnittpunkte(:,1)<=-groesse+0.000001),:);

oben = [oben(:,1), oben(:,2)];
unten = [unten(:,1), unten(:,2)];
links = [links(:,1), links(:,3)];
rechts = [rechts(:,1), rechts(:,3)];
vorne = [vorne(:,2), vorne(:,3)];
hinten = [hinten(:,2), hinten(:,3)];

xgrid = -groesse:0.5:groesse;
ygrid = -groesse:0.5:groesse;

figure
subplot(3,5,3)
N = hist3(oben, {xgrid, ygrid});
handler(1) = pcolor(xgrid, ygrid, N');
max_N(1) = max(max(N));
% colorbar
title("Oben")

subplot(3,5,13)
N = hist3(unten, {xgrid, ygrid});
handler(2) =pcolor(xgrid, ygrid, N');
max_N(2) = max(max(N));
% colorbar
title("Unten")

subplot(3,5,6)
N = hist3(links, {xgrid, ygrid});
handler(3) = pcolor(xgrid, ygrid, N');
max_N(3) = max(max(N));
% colorbar
title("Links")

subplot(3,5,9)
N = hist3(rechts, {xgrid, ygrid});
handler(4) = pcolor(xgrid, ygrid, N');
max_N(4) = max(max(N));
% colorbar
title("Rechts")

subplot(3,5,7)
N = hist3(vorne, {xgrid, ygrid});
handler(5) = pcolor(xgrid, ygrid, N');
max_N(5) = max(max(N));
% colorbar
title("Vorne")

subplot(3,5,10)
N = hist3(hinten, {xgrid, ygrid});
handler(6) = pcolor(xgrid, ygrid, N');
max_N(6) = max(max(N));
% colorbar
title("Hinten")
max_graphik = find(max_N == max(max_N))
colorbar('Position', [0.93  0.05  0.03  0.9], 'Parent', handler(max_graphik))


% figure(1)
% 
% plot3(X(:,:)',Y(:,:)',Z(:,:)')
% hold on
% plot3(X(:,:)',Y(:,:)',Z(:,:)')%,'.')
% groesse = groesse +3;
% xlim([-groesse,groesse])
% ylim([-groesse,groesse])
% zlim([-groesse,groesse])
% hold on
% grid on



