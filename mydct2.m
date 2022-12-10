clc;
clear all;
close all;


%Q Array
Q1=[
16 11 10 16 24 40 51 61    
12 12 14 19 26 58 60 55
14 13 16 24 40 57 69 56
14 17 22 29 51 87 80 62
18 22 37 56 68 109 103 77
24 35 55 64 81 104 113 92
49 64 78 87 103 121 120 101
72 92 95 98 112 100 103 99
];



%dctPerLine
DctLineByLine=CalculateDCTLinePerLine(Q1);
Size=length(Q1);
%DctperColumn
DctColumnByColumn=calculateDctColumnByColumn(DctLineByLine,Size);
%finalArrayDCT
ArraFFTyDCT=concreteArrayDCT(DctColumnByColumn,Size);

%DCT With dct2 matlab function
DctImage=dct2(Q1);


figure,imshow(uint8(ArraFFTyDCT));
figure,imshow(uint8(DctImage));



function ArrayDCT=concreteArrayDCT(DctColumnByColumn,N)
    temp=0;
    for(i=1:1:N)
        for(j=1:1:N)
            if temp+i>N*N
                break
            end

            ArrayDCT(i,j)=DctColumnByColumn(i+temp);
            temp=temp+N;
        end
        temp=0;
    end
end






function DctColumnByColumn=calculateDctColumnByColumn(DctLineByLine,N)
    
    k=0;
    Y=N*N;
    DctColumnByColumn=[];
    for i=1:1:N
        for j=1:1:N  
            if k+i>Y
                break
            end
        column(j)=DctLineByLine(i+k);
        k=k+N;  
        end
        k=0;
        DctColumnByColumn=[DctColumnByColumn,calculateDCT(column)];
    end

end




function DctLineByLine=CalculateDCTLinePerLine(Q)
    N=length(Q);
    DctLineByLine=[];
    for i=1:1:N
        for j=1:1:N
            lineArray(j)=Q(i,j);
           
        end
         
        DctLineByLine=[DctLineByLine,calculateDCT(lineArray)];    
    end  

end



function Fu=calculateDCT(Q)
    N=length(Q);
    powerE=(-1j*pi)/(2*N);
    for u=0:2*N-1
        gx(u+1)=(G_X(Q,u,N));
    end

    FFT=fft(gx);

    for(i=1:1:N)
        u=i-1;
        if u==0
            Fu(i)=(FFT(i)*sqrt(N)*exp(powerE*u))/(2*N);
        else
            Fu(i)=(FFT(i)*sqrt(2)*sqrt(N)*exp(powerE*u))/(2*N);
        end
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

end





