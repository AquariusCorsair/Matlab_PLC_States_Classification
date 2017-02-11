function featureDimension = preprocess(minLen,subLen,featureExtractMethod)
%% ==========  Part one: load files into matrix sss =============
class_n={'JMP','LN','SIN','SQI','XPY'};
cn = length(class_n);
num = length(dir(['data/',class_n{1}])) - 2;%file numbers per class
FILE_SIZE = 1e4;%upper-limit of FILE_SIZE

sss = zeros(FILE_SIZE,cn*num);
fileLen = zeros(1,cn*num);

for j = 1:cn
    cur = class_n{j};
    file = dir(['data/',cur]);
    if num ~= length(file) - 2  
        disp( [ 'file number for ',cur,'is not ', num2str( num ),'!!']);
    end
 
    for i=1:num
       [ss,Fs] = audioread(['data/',cur,'/',file(i+2).name]);
       
       fileLen(1,(j-1)*num+i) = length(ss);
       sss(1:length(ss),(j-1)*num+i) = ss(:,1);
    end
end
disp( [ 'Sampling rate Fs :' num2str( Fs )]);

%% ============= Part two: take user input to reshape sss ==============
if nargin < 2 
    disp( [ 'Average file length : ',num2str( sum(fileLen)/length(fileLen) )]);
    figure
    hist(fileLen,500);%display a 500 bins histogram
    title('histogram of length per class');
    xlabel('length (samples)');
    ylabel('class number');
    minLen = input ('file size lower boundry = ');%4.3e5
    subLen = input ('subfile length = ');%subLen is the length of a example fed to feature extraction
end
Num = floor(minLen/subLen); %cut each .wav according to subLen
minLen = subLen*Num;

s=zeros(minLen,cn*num);
for j=1:(cn*num)
    s(:,j) = sss(1:minLen,j);
end
s=reshape(s,[subLen,cn*num*Num]);

%% ================== Part three: creat label matrix ======================
label = zeros(cn*num*Num,1);
numPerClass = num*Num;
for j=1:(cn*numPerClass)
    curClassIndex = floor((j-1)/numPerClass)+1;
    label(j) = curClassIndex;

%   (OPTIONAL) Save each column of s as a .wav file-----------------------
%    curFileIndex = mod(j-1,numPerClass)+1;
%    wS=s(:,j);
%    filePath = ['tmp/' class_n{curClassIndex} '/' num2str(curFileIndex) '.wav'];
%    audiowrite(filePath,wS,Fs); 
end
%% ============= Part Four: feature extraction(FFT/pwelch...) =============
[en, ~] = size(s);
switch featureExtractMethod 
    case 1 % fft
        f = fft(s,en);% each column of s is an example
        data = f';%each row of data is an example
        [~, fn] = size(data);
        data = abs(data(:,1:int32(fn/2)));
    case 2 % pwelch
        p = pwelch(s,en);
        data = p';
    otherwise
        disp('feature extraction method does not exist');
        data = [];
end

[~, fn] = size(data);
featureDimension = fn;
disp(['feature dimension = ',num2str(featureDimension)]);
dataFeature = [label data];
save ('./tmp/dataFeature.mat','dataFeature');
save ('./tmp/label.mat','label');


