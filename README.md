# classification of PLC instruction

## Description
1. This program extracted frquency features of input data(EM emission of PLC's running Instruction loop. The five classes of them are stored in `./data/[JMP,LN,SIN,SQI,XPY]`), by slidingwindow and DFT/pwelch. 
2. And, after applying pca to the data features, it used machine learning algorithm to train a model (stored in stored in `./tmp/classifier_windowed.mat`)
3. It calculated the confusion matrix(stored in `./tmp/confusionMatrixTest.mat`) after a certain number of trails(in each trail, data will be repermutted).
4. And it predicts realtime testing data (stored in `./data/testCases`) classes against time.
5. After getting the raw realtime states swithing data serial A[n], it applied a sliding window to compare the statistical attributes of A[n], i.e. distribution histogram, against the training data and deside whether there is an abnormal state, i.e. `Euclidean Distance` is big. 

## Run in matlab R2016b
1. Download the data file from https://drive.google.com/open?id=0B_HlYDbGYXySQjNON2dTdFFXeWM. Extract it to the current path.
2. Trail to compute confusion matrix. In Matlab Shell, run:

  > runExperiments_

3. Predict realtime state transition. In Matlab Shell, run:

  > stateDetection

  * Output figure 1 is the raw prediction (comming right out of classifier), in forms of `<class index>` against `time`.
[figure 1 Raw Classification](tmp/pics/fig1.jpg)

  * Output figure 2 is the Distribution within sliding window(represented as classes instances count) against time.
[figure 2 Distribution Within Sliding Window](tmp/pics/fig2.jpg)

  * Output figure 3 is the abnormal states detection result. When the Euclidean Distance from template is large, we found 
[figure 3 Abnormal States Detection](tmp/pics/fig3.jpg)
