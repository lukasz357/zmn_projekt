function [] = mes()
%dane wejsciowe
V1=100;
V2=110;
E1=100;
E2=5;
xp=20; %d³ugoœæ p³¹szczyzny
yp=15;  %szerokoœæ p³aszczyzny
m=xp*yp;
xw=round(xp*3/4);  %d³ugoœæ wciêcia
yw=round(yp/10);   %szerokoœæ wciêcia
yb=round(yp*3/4);   %odleg³oœæ wciêcia od górnego brzegu
y0=round(yp/15);  %odleg³oœæ p³ytki od wciêcia
x0=round(xp/10);  %d³ugoœæ p³ytko
pp=[xw-x0 yb-yw-y0];  %po³o¿enie pocz¹tku p³ytki
kp=[xw yb-yw-y0];  %po³o¿enie koñca p³ytki
%podzia³ p³¹szczyzny na trójk¹ty
x=1:xp;
y=1:yp;
[xx yy]=meshgrid(x,y);
W=[reshape(xx,m,1) reshape(yy,m,1)];
N=reshape([1:m],yp,xp);
for i=1:xp-1
  K=[N(1:yb-1,i) N(1:yb-1,i+1) N(2:yb,i);
     N(1:yb-1,i+1) N(2:yb,i+1) N(2:yb,i)];       
    E=ones(length(K),1)*E2;
    K=[K E];
    if i==1
        T=K;
    else
        T=[T;K];
    end
end
for i=1:xw-1
    K=[N(yb:yb+yw-1,i) N(yb:yb+yw-1,i+1) N(yb+1:yb+yw,i);
       N(yb:yb+yw-1,i+1) N(yb+1:yb+yw,i+1) N(yb+1:yb+yw,i)];  
    E=ones(length(K),1)*E1;
    K=[K E];
    T=[T;K];
end
for i=xw:xp-1
    K=[N(yb:yb+yw-1,i) N(yb:yb+yw-1,i+1) N(yb+1:yb+yw,i);
       N(yb:yb+yw-1,i+1) N(yb+1:yb+yw,i+1) N(yb+1:yb+yw,i)];        
    E=ones(length(K),1)*E2;
    K=[K E];
    T=[T;K];
end
for i=1:xp-1
    K=[N(yb+yw:yp-1,i) N(yb+yw:yp-1,i+1) N(yb+yw+1:yp,i);
       N(yb+yw:yp-1,i+1) N(yb+yw+1:yp,i+1) N(yb+yw+1:yp,i)];    
    E=ones(length(K),1)*E2;
    K=[K E];
    T=[T;K];
end
%trisurf(T(:,1:3),W(:,1),W(:,2),W(:,2))

%obliczenia
H=obliczH(W,T,[yp xp]);
B=zeros(xp*yp,1);
for i=1:yp
    p=H(i,i);
    H(i,:)=0;
    H(i,i)=p;
    B(i)=V1*p;
end
for i=pp(1)*yp+pp(2):yp:kp(1)*yp+kp(2)
    p=H(i,i);
    H(i,:)=0;
    H(i,i)=p;
    B(i)=V2*p;
end
V=H\B;
K=reshape(V,yp,xp);
contour([1:xp],[1:yp],K,50);
end

