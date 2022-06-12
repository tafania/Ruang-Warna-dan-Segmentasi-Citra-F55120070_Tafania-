%=================> Tugas PCD <===================
%==========> Tafania Natalia Kasaedja <===========
%=================> F55120070 <===================
%==============> Ruang warna YCbCr <==============

clc;
clear;
close all;
warning off all;

%Membaca citra asli
img = imread('emoji.jpg')

%Konversi citra RGB to YCbCr
YCbCr = rgb2ycbcr(img);

%Konversi citra YCbCr to Grayscale
YC = double(rgb2gray(YCbCr));

%Proses segmentasi citra menggunakan algoritma K-Means Clusteing
%membuat 2 kelas baru, yaitu object dan backround
numberOfClasses = 2;
indexes = kmeans(YC(:), numberOfClasses);
%mendeklarasikan variabel kelas image dari data vektor menjadi matriks
classImage = reshape(indexes, size(YC));

%Proses region object/pemilihan object pada citra
class = zeros(size(YC));
area = zeros(numberOfClasses,1);
%tahap perulangan untuk menyelesaikan pemilihan objek pada kelas 1 hingga n
for n = 1 : numberOfClasses
    class(:,:,n) = classImage == n;
    area(n) = sum(sum(class(:,:,n)));
end

%mencari kelas yang memiliki luas area paling Minimum
[~, min_area] = min(area);
%melakukan pemilihan Object perdasarkan area kelas terkecil
object = classImage == min_area;

%operasi morfologi untuk mengurangi noise pada segmentasi
%operasi yang digunakan yaitu median filter
bw = medfilt2(object,[5 5]);%ukuran kernel
%menghilangkan object yang meniliki luas dibawah 9000
bw = bwareaopen(bw,9000);

%Tahap ekstraksi Bounding Box pada Object
s = regionprops(bw, 'BoundingBox');
bbox = cat(1,s.BoundingBox);

%Menampilkan Bounding Box Hasil Segmentasi
RGB = insertShape(img,'FilledRectangle',bbox,'Color','magenta','Opacity',0.3);
RGB = insertObjectAnnotation(RGB,'rectangle',bbox,'Object','TextBoxOpacity',0.9,'FontSize',18);

%Menampilkan Watermark
text_str = ['©Tafania_F55120070']; 
position = [200 240]; 
box_color = ('white');
text = insertText (RGB, position, text_str, 'Fontsize', 50, 'BoxColor', box_color, 'BoxOpacity', 0.2, 'TextColor', 'Black'); 

%menampilkan citra dalam bentuk baris dan kolom
figure
subplot (2,4,1),imshow(img);title('Citra Asli RGB');
subplot (2,4,2),imshow(YCbCr);title('Konversi Citra RGB to YCbCr');
subplot (2,4,3),imshow(YC,[]);title('Konversi YCbCr to Grayscale');
subplot (2,4,4),imshow(classImage,[]);title('Tresholding');
subplot (2,4,5),imshow(object);title('Citra Kelas Terkecil');
subplot (2,4,6),imshow(bw);title('Operasi Morfologi(Median Filter)');
subplot (2,4,7),imshow(RGB);title('Deteksi Object');
subplot (2,4,8),imshow(text);title('© copyright');