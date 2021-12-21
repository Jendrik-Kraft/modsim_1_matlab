function [drehmatrix] = BerechneDrehmatrix(alpha, dimension)
    % Bestimmen der Drehmatrix abhängig von der Dimension (1=x, 2=y, 3=z) 
    % und dem Winkel alpha um den gedreht werden soll (in rad)
    switch dimension
        case 1
            drehmatrix = [1, 0     ,       0;
                           0, cos(alpha), -sin(alpha);
                           0, sin(alpha),  cos(alpha);];
        case 2
            drehmatrix = [cos(alpha),  0,  sin(alpha);
                          0,       1,       0;
                          -sin(alpha), 0,  cos(alpha);];
            
        case 3
            drehmatrix = [cos(alpha), -sin(alpha), 0;
                          sin(alpha),  cos(alpha), 0;
                          0,            0, 1;];
    end