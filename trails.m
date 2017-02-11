function [accMean, accVia] = trails(times,featureSize)
N=times;    %training times
load('./tmp/label.mat');
load('./tmp/dataFeature.mat');

%% === test for N times and calculate the mean and variance for accuracy ===
res = zeros(N,1);
for i = 1: N
    disp(['trial ',num2str(i)]);
    [train,test] = permuteTT(5,0.6,dataFeature,label);
    [c,~]=trainClassifier(train,featureSize);
    res(i,1) = testClassifier(test,c);  
end
%save('./tmp/confusionMatrixTrain.mat','c');
accMean = sum(res)/length(res);
accVia = sum(abs(res-accMean.*ones(N,1)))/length(res);

disp(['accMean = ', num2str(accMean)]);
disp(['accVia = ', num2str(accVia)]);
%% ============== (Optional)plot score for trained data ================
if 0
[y,sco] = c.predictFcn(train(:,2:length(test)));
figure
plot(1:length(sco),sco);
title('score for training data');
end