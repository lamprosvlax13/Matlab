
clc;
clear all;
close all;

fx=[46 31 56 42 45 67 86 55 ];

%SIZE fx
N=length(fx);

%Calculate Gx
for(i=0:2*N-1)
    gx(i+1)=G_X(fx,i,N);
end    

%FFT 
Gu=fft(gx);


% Calculate Fu from Gu
Fu=[];
powerE=-1j*pi/(2*N);
u=0;
for(i=1:1:N)
    u=i-1;
    if u==0
       Fu(i)=(Gu(i)*sqrt(N)*exp(powerE*u))/(2*N);
    else
       Fu(i)=(Gu(i)*sqrt(2)*sqrt(N)*exp(powerE*u))/(2*N);
    end
   
end

function gx=G_X(fx,position,size)
    gx=[];
    u=position+1;
    if position>=0 & position<=size-1
        gx=fx(u);
    else if position>=size & position<=(2*size)-1
       u=position-1;     
       tempPos=2*size -1 -u;
       gx=fx(tempPos);
    
    end
    end
return
end
