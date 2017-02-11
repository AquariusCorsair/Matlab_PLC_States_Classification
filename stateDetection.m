%function stateDetection(winLen,featureExtractMethod)
winLen=400;
featureExtractMethod=1;
computeTemplate = 0;
%% ========== load trianedClassifier and testing data ================
load('./tmp/classifier_windowed.mat');%=>trainedClassifier
%[s,Fs] = audioread('./data/testCases/case1.wav');
s=load('./data/testCases/case3.dat');

if ~computeTemplate
    %s=s(240000:length(s),:);
    tmp=load('./data/testCases/case5.dat');
    s=[s;tmp];
end
Fs=1e6;
%% === extract features of testing data and feed them to the classifier =====
reLen = floor(length(s)/winLen)*winLen;
s = s(1:reLen);
s = reshape(s,[winLen,reLen/winLen]);

switch featureExtractMethod 
    case 1 % fft
        s = fft(s,winLen);% each column of s is an example
        s = s';%each row of data is an example
        [~, fn] = size(s);
        s = abs(s(:,1:int32(fn/2)));
    case 2 % pwelch
        p = pwelch(s,winLen);
        s = p';
    otherwise
        disp('feature extraction method does not exist');
        s = [];
end

% figure
% mesh(s);
% figure
% plot(1:length(s(3,:)),s(3,:));
% disp(num2str(size(s)));

[yfit1,score1] = trainedClassifier.predictFcn(s);
figure
plot(1:length(yfit1),yfit1);
title('PLC state transition prediction raw result from classifier');
xlabel('time(ms)');
ylabel('state index');

% figure 
% hist(yfit1);
%% ================ sliding windows compute distribution ============================
len_yfit1=length(yfit1);
windowSize = 1000;
r = len_yfit1-windowSize;
M = zeros(r,5);
score = zeros(r,1);

for i=1:r
    %get the distribution in yfit1(i:i+windowSize,1)
    M(i,:)=hist(yfit1(i:i+windowSize,1),5);
    if ~computeTemplate
        load('./tmp/T_normal.mat');%=>T_normal
        score(i,1) = sum(abs(sqrt(M(i,:)-T_normal)));
    end
end

if computeTemplate
    % caculate the mean of each colum in M to form the template T_normal
    T_normal = mean(M,1);
    save ('./tmp/T_normal.mat','T_normal');
    save('./tmp/yfit1normal.mat','yfit1');
end

if ~computeTemplate
    save('./tmp/yfit1mix.mat','yfit1');
    figure
    xlin=linspace(1,50,length(M));
    plot(xlin,M(:,1),':','DisplayName','JMP');
    hold on
    plot(xlin,M(:,2),'-','DisplayName','LN');
    hold on
    plot(xlin,M(:,3),'-','Linewidth',1.2,'DisplayName','SIN');
    hold on
    plot(xlin,M(:,4),'-.','DisplayName','SQI');
    hold on
    plot(xlin,M(:,5),'--','DisplayName','XPY');
    legend('show')
    set(gca,'fontsize',14);
    t1=xlabel('time(ms)');
    t2=ylabel('marker count');
    t1.FontSize=16;
    t2.FontSize=16;
    %xlim([0,700]);
    
    figure
    xlin=linspace(0,20,length(score));
    plot(xlin,score,'-');
    set(gca,'fontsize',14);
    t1=xlabel('time(ms)');
    t2=ylabel('Euclidean Distence');
    t1.FontSize=16;
    t2.FontSize=16;
    %ylim([0,50]);
    save('tmp/score.mat','score');
end
%% ============ generate dtw model based on PLC program and test =========
% numPerState = int32(0.005*Fs/winLen);
% stateTran = [4,5,1,4,5,1,3,2,1,3,2,1];% for a period
% periodLen = length(stateTran)*numPerState;
% periodNumPerTest = int32(length(M)/periodLen);
% dtwM = generateDtwModel(stateTran, periodNumPerTest);
% figure, dtw(M,dtwM);
% xlim([6000,7500]);

