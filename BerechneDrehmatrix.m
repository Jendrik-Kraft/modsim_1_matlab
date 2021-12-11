function [drehmatrix] = BerechneDrehmatrix(a, dimension)
    switch dimension
        case 1
            drehmatrix = [1, 0     ,       0;
                           0, cos(a), -sin(a);
                           0, sin(a),  cos(a);];
        case 2
            drehmatrix = [cos(a),  0,  sin(a);
                          0,       1,       0;
                          -sin(a), 0,  cos(a);];
            
        case 3
            drehmatrix = [cos(a), -sin(a), 0;
                          sin(a),  cos(a), 0;
                          0,            0, 1;];
    end

% R_x = [1, 0     ,       0;
%            0, cos(a), -sin(a);
%            0, sin(a),  cos(a);];
% 
%     R_y = [cos(a),  0,  sin(a);
%            0,       1,       0;
%            -sin(a), 0,  cos(a);];
%        
%     R_z = [cos(a), -sin(a), 0;
%            sin(a),  cos(a), 0;
%            0,            0, 1;];