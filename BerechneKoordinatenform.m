function [A,B,C,D] = BerechneKoordinatenform(P1,P2,P3)
    for n=1:6
        normal(:,n) = cross(P1(n,:)-P2(n,:), P1(n,:)-P3(n,:));
        A(n) = normal(1,n);
        B(n) = normal(2,n);
        C(n) = normal(3,n);
        D(n) = -dot(normal(:,n),P1(n,:));
    end
end