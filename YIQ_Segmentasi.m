%=================> Tugas PCD <==================
%==========> Tafania Natalia Kasaedja <==========
%=================> F55120070 <==================

clc;
clear;
close all;
warning off all;

%membaca citra
img = imread('buah.jpg')

%rgb to ycbcr
YIQ = uint8(zeros(size(img)));
for i = 1:size(img,1)
    for j = 1:size(img,2)
        YIQ(i,j,1)=0.299*img(i,j,2)+0.587*img(i,j,1)+0.114*img(i,j,1);
        YIQ(i,j,3)=0.596*img(i,j,3)+0.274*img(i,j,2)+0.322*img(i,j,2);
        YIQ(i,j,2)=0.211*img(i,j,2)+0.532*img(i,j,3)+0.312*img(i,j,3);
    end
end

%YCbCr to Grayscale
YI = double(rgb2gray(YIQ));

%konvolusi dengan operator "Roberts"
robertshor = [0 1; -1 0];
robertsver = [1 0; 0 -1];
YIx = conv2(YI, robertshor, 'same');
YIy = conv2(YI, robertsver, 'same');
J = sqrt ((YIx.^2+YIy.^2));

%Melakukan tresholding citra
K = uint8(J);
L = imbinarize(K,0.08);
M = imfill(L,'holes');
N = bwareaopen(M,1500);

%mengambil bounding box
[labeled, numObjects] = bwlabel(N,8); %black and white

%menampilkan citra dalam bentuk baris dan kolom
figure
subplot (2,4,1),imshow(img);title('Citra Asli');
subplot (2,4,2),imshow(YIQ);title('RGB to YIQ');
subplot (2,4,3),imshow(YI,[]);title('YIQ to Grayscale');
subplot (2,4,4),imshow(L);title('Tresholding');
subplot (2,4,5),imshow(M);title('Filing Holes');
subplot (2,4,6),imshow(N);title('Morfologi');
subplot (2,4,7),imshow(labeled,[]);title('Label');
stats = regionprops(labeled, 'BoundingBox');
bbox = cat(1,stats.BoundingBox);
%menampilkan hasil segmentasi
subplot (2,4,8),imshow(img);title('Deteksi');
hold on
for idx = 1:numObjects
    h = rectangle('Position',bbox(idx,:),'LineWidth',3);
    set (h,'EdgeColor',[0 0 1]);
    hold on;
end

%tampilkan jumlah object
title(['Jumlah Object : ', num2str(numObjects)])
hold off;