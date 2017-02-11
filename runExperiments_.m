%--------------------
trailTimes = 5;
featureExtractMethod = 1;
% 1: DFT
% 2: pwelch
minLen = 4.3e5;
subLen = 400;
%---------------------

featureDimension = preprocess(minLen,subLen,featureExtractMethod);
[accMean, accVia] = trails(trailTimes,featureDimension);

C = load('./tmp/confusionMatrixTest.mat');
disp('a typical Confusion matrix:')
disp(C.C)