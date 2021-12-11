function [richtiger_Schnittpunkt] = BerechneSchnittpunkt(stuetz_v, richtungs_v, A, B, C, D, n, groesse)
    % TODO A B C D in eine Matrix zusammen schreiben
    Schnittpunkt=zeros(n,3,6);
    t=zeros(n,1);
    for pz=1:n %Photonenzahl
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

        % TODO Klären warum +0.00001 nötig ist
        entfernungen = sqrt((Schnittpunkt(:,1,:)-stuetz_v(1)).^2+...
                            (Schnittpunkt(:,2,:)-stuetz_v(2)).^2+...
                            (Schnittpunkt(:,3,:)-stuetz_v(3)).^2);

        photon_nr=find(Schnittpunkt(:,1,wand)<groesse+0.00001 & Schnittpunkt(:,1,wand)>=-groesse-0.00001&...
                                 Schnittpunkt(:,2,wand)<groesse+0.00001 & Schnittpunkt(:,2,wand)>=-groesse-0.00001&...
                                 Schnittpunkt(:,3,wand)<groesse+0.00001 & Schnittpunkt(:,3,wand)>=-groesse-0.00001);
                                 %entfernungen(:,wand)>0);
        %Speichern dieser Schnittpunkte, ermitteln ob schon ein Schnittpunkt
        %eingetragen ist und wenn das der Fall ist, ermitteln welche Wand näher
        %am ursprünglich ausgewürfelten Punkt liegt - und damit die richitge
        %ist
        for i=1:length(photon_nr)
            if richtiger_Schnittpunkt(photon_nr,1) ~= 0
                laenge_1=sqrt((Schnittpunkt(photon_nr,1,wand)-richtungs_v(photon_nr,1)).^2+...
                    (Schnittpunkt(photon_nr,2,wand)-richtungs_v(photon_nr,2)).^2+...
                    (Schnittpunkt(photon_nr,3,wand)-richtungs_v(photon_nr,3)).^2);
                laenge_2=sqrt((richtiger_Schnittpunkt(photon_nr,1)-richtungs_v(photon_nr,1)).^2+...
                    (richtiger_Schnittpunkt(photon_nr,2)-richtungs_v(photon_nr,2)).^2+...
                    (richtiger_Schnittpunkt(photon_nr,3)-richtungs_v(photon_nr,3)).^2);


                if laenge_1(i) < laenge_2(i)
                    richtiger_Schnittpunkt(photon_nr(i),:) = Schnittpunkt(photon_nr(i),:,wand);
                end

            else
                richtiger_Schnittpunkt(photon_nr,:) = Schnittpunkt(photon_nr,:,wand);
            end
        end
    end