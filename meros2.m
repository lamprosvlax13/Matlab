clc;
clear all;
close all;
%read image
image=imread('cameraman.tif');


%Entropy
Entropy = entropy(image);
fprintf("The Entropy before Transformation : %f", Entropy);
fprintf("\n");
%disp(Entropy);

%Q Array
Q=[
16 11 10 16 24 40 51 61    
12 12 14 19 26 58 60 55
14 13 16 24 40 57 69 56
14 17 22 29 51 87 80 62
18 22 37 56 68 109 103 77
24 35 55 64 81 104 113 92
49 64 78 87 103 121 120 101
72 92 95 98 112 100 103 99
];



    DctTransform=calculateDctTransform(Q,image);
    calculatePsnr(image,DctTransform);

    
    DctTransform=calculateDctTransform(3*Q,image);
    calculatePsnr(image,DctTransform);

    DctTransform=calculateDctTransform(5*Q,image);
    calculatePsnr(image,DctTransform);
    
    


function DctTransform=calculateDctTransform(Q,OriginalImage)
    %split images  8 x 8 blocks and dct2 per Block and kvanthsh suntelestnw
    %ka9e block
    DCT2_fUN=@(block_struct) round(dct2(block_struct.data)./Q);    
    matrixWithDctPerBlock = blockproc(OriginalImage,[8 8],DCT2_fUN); 
   %{
       2h ulopoihsh xwris blockproc

       for i=1:8:256
           for j=1:8:256
                matrixWithDctPerBlock(i:i+7,j:j+7)=round(dct2(OriginalImage(i:i+7,j:j+7))./Q);
            end
       end
   %}

  
    %n= Q.*(m,[8,8]);
    %vriskw entropia meta thn kvanthsh apoluth timh
    Entropy = entropy(abs(matrixWithDctPerBlock));
   
    fprintf("The Entropy after Transformation: %f", Entropy);
    fprintf("\n");


    %meta thn kvanthsh vriskw mhdenika
    
    sumOfZeros=0;
    for i=1:1:256
        for j=1:1:256
            if matrixWithDctPerBlock(i,j)==0
                sumOfZeros=sumOfZeros+1;
            end
        end
    end   
   
    fprintf("The Sum of Zeros %d", sumOfZeros);
    fprintf("\n");
    matrixWithDctPerBlockInverseQuantization = blockproc(matrixWithDctPerBlock,[8 8],@(block_struct) (block_struct.data).*Q);


    %IDCT  per Block
    IDCT2_fUN=@(block_struct) idct2(block_struct.data);
    idctIm = blockproc(matrixWithDctPerBlockInverseQuantization,[8 8],IDCT2_fUN);


    %{

    2 ulopoihsh 

    for i=1:8:256
        for j=1:8:256
            idctIm(i:i+7,j:j+7)=idct2(matrixWithDctPerBlock(i:i+7,j:j+7).*Q);
        end
    end

%}
    

    

    %metatropo se uint8
    for i=1:length(idctIm)
        for j=1:length(idctIm)
            if idctIm(i,j)<0.0
                ArrayUint8(i,j)=0;
            else if idctIm(i,j)>255
                ArrayUint8(i,j)=255;
            else
                ArrayUint8(i,j)=uint8(idctIm(i,j));
            end
            end
        end
     end

    
    figure , imshow(ArrayUint8);
   
    DctTransform=idctIm;

end
  
function calculatePsnr(originalImage,DctImage)
%PSNR
    PSNR_IMAGE1=0;
    originalImage= double(originalImage);
    DctImage =double(DctImage);
    error=originalImage-DctImage;
    if error ~=0
        [h,r]=size(originalImage);
        M1=0;
        for i=1:1:h
            for j=1:1:r
                M1=M1+(error(i,j))^2;
            end
        end

        MSE_IMAGE1=M1/(h*r);
        PSNR_IMAGE1=20*log10(255/sqrt(MSE_IMAGE1));
    else
        PSNR_IMAGE1=100;
    end    
  
    
    fprintf("The PSNR is %f", PSNR_IMAGE1);
    fprintf("\n");
end   




