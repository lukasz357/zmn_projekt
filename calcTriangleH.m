function [h] = calcTriangleH(w1, w2, w3, e)
    area = det([1 w1(1) w1(2)
                1 w2(1) w2(2)
                1 w3(1) w3(2)])/2;
            
    b1 = w2(2) - w3(2);
    b2 = w3(2) - w1(2);
    b3 = w1(2) - w2(2);
    
    c1 = w3(1) - w2(1);
    c2 = w1(1) - w3(1);
    c3 = w2(1) - w1(1);
    
    h = e * [b1*b1+c1*c1 b1*b2+c1*c2 b1*b3+c1*c3
             b2*b1+c2*c1 b2*b2+c2*c2 b2*b3+c2*c3
             c3*b1+c3*c1 b3*b2+c3*c2 b3*b3+c3*c3] / 4 * area;
end