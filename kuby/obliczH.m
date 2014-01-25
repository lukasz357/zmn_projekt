function [ H ] = obliczH( W,T,s)
n=length(T);
H=zeros(s(1)*s(2),s(1)*s(2));
for it=1:n;
    A=[1 W(T(it,1),1) W(T(it,1),2);
       1 W(T(it,2),1) W(T(it,2),2);
       1 W(T(it,3),1) W(T(it,3),2)];  
    pole=0.5*det(A);
    bi=A(2,3)-A(3,3);
    bj=A(3,3)-A(1,3);
    bk=A(1,3)-A(2,3);
    ci=A(3,2)-A(2,2);
    cj=A(1,2)-A(3,2);
    ck=A(2,2)-A(1,2);
    K=[bi*bi+ci*ci bi*bj+ci*cj bi*bk+ci*ck;
       bj*bi+cj*ci bj*bj+cj*cj bj*bk+cj*ck;
       bk*bi+ck*ci bk*bj+ck*cj bk*bk+ck*ck];
    e=T(it,4);
    l=1/(4*pole);
    he=e*K*l;   
    H(T(it,1:3),T(it,1:3))=H(T(it,1:3),T(it,1:3))+he;
end

end

