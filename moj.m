clear all;
close all;
%dane wejsciowe
V1=100;
V2=110;
E1=100;
E2=5;

xp=10; %szerokoœæ p³aszczyzny
yp=6;  %wysokoœæ p³aszczyzny

v1Pos = [1 1; yp+1 1];
v2Pos = [round(yp/2) round(xp-xp/5); round(yp/2) xp+1];

a = round(yp/2);

xE1 = round(xp*3/10);  %szerokoœæ E1
xE2 = round(xp-xE1);
xV1 = round(xp *2/10); %d³ugoœæ p³ytki wym. V1


% yw=round(yp/10);   %szerokoœæ wciêcia
% yb=round(yp*3/4);   %odleg³oœæ wciêcia od górnego brzegu
% y0=round(yp/15);  %odleg³oœæ p³ytki od wciêcia
% x0=round(xp/10);  %d³ugoœæ p³ytko
% pp=[xw-x0 yb-yw-y0];  %po³o¿enie pocz¹tku p³ytki
% kp=[xw yb-yw-y0];  %po³o¿enie koñca p³ytki
% %podzia³ p³¹szczyzny na trójk¹ty
% x=1:xp;
% y=1:yp;

ilosc_poziomych = a*2+1;

Y=zeros(1,ilosc_poziomych);
y_diff = yp/(ilosc_poziomych-1);
Y(1) = 1;
for i=2:ilosc_poziomych,
    Y(i) = Y(1)+(y_diff*(i-1));
end

X=zeros(1,(a+1)+(xp-xE1));
xE1_diff = xE1/a;
X(1) = 1;
for i=2:(a+1),
   X(i)=X(1)+(xE1_diff*(i-1));
end

xE2_diff = 1;
for i=(a+2):(a+1)+(xp-xE1),
   X(i)=X(i-1)+xE2_diff;
end

x_len = length(X);
y_len = length(Y);
nodeCount = x_len * y_len;
W=zeros(nodeCount,2);
k=1;
for i=1:x_len,
    for j=1:y_len,
        W(k,1)=Y(j);
        W(k,2)=X(i);
        k = k+1;
    end
end

N=reshape([1:nodeCount],y_len,x_len);

% Utworzenie trójk¹tów
f = @(x)((a/xE1)*x); %funkcja do sprawdzania czy punkt le¿y na ukoœnej

[x_N, y_N] = size(N);

T=zeros(round(nodeCount*3/2),4);
k=1;
for j=1:y_N-1,
    for i=1:x_N-1,
        T(k,:,:)	= [N(i,j) N(i+1,j) N(i+1,j+1) 0];
        T(k+1,:,:)  = [N(i,j) N(i+1,j+1) N(i,j+1) 0];
        k = k+2;
    end
end

for i=1:length(T),
    w1 = W(T(i,1),:);
    w2 = W(T(i,2),:);
    w3 = W(T(i,3),:);
    if  w1(1,1) < (xE1+1) || w2(1,1) < (xE1+1) || w3(1,1) < (xE1+1),
        if w1(1,2) > f(w1(1,1)) || w2(1,2) > f(w2(1,1)) || w3(1,2) > f(w3(1,1)),
            T(i,4) = E1;
        else
            T(i,4) = E2;
        end
    else
        T(i,4) = E2;
    end
end

%trisurf(T(:,1:3),W(:,1),W(:,2),W(:,2));

n=length(T);
H=zeros(nodeCount,nodeCount);

for i=1:n
    h = calcTriangleH(W(T(i,1),:), W(T(i,2),:), W(T(i,3),:), T(i,4));
    H(T(i,1:3),T(i,1:3)) = H(T(i,1:3),T(i,1:3)) + h;
end

%obliczenia

b=zeros(nodeCount,1);
% for i=1:yp
%     p=H(i,i);
%     H(i,:)=0;
%     H(i,i)=p;
%     b(i)=V1*p;
% end
for i = v1Pos(1, 2):v1Pos(2, 2)
    for j=v1Pos(1, 1):v1Pos(2, 1)
        c = ((yp+1)*(i-1))+j;
        tmp = H(c, c);
        H(c,:)=0;
        H(c, c)=tmp;
        b(c)=V1*tmp;
    end
end
% 
for i = v2Pos(1, 2):v2Pos(2, 2)
    for j=v2Pos(1, 1):v2Pos(2, 1)
        c = ((yp+1)*(i-1))+j;
        tmp = H(c, c);
        H(c,:)=0;
        H(c, c)=tmp;
        b(c)=V2*tmp;
    end
end

V=H\b;
K=reshape(V,y_len,x_len);
contour([1:x_len],[1:y_len],K,50);


