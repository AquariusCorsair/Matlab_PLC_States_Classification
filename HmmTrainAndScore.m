% hmm training using yfit1normal
load('./tmp/yfit1normal.mat');
train=yfit1;

trans = [0.1,0.9,0,0,0;
    0,0.1,0.9,0,0;
    0,0,0.1,0.9,0;
    0,0,0,0.1,0.9;
    0.9,0,0,0,0.1];
S=4/5;
O=1/20;
emis = [S,O,O,O,O;
    O,S,O,O,O;
    O,O,S,O,O;
    O,O,O,S,O;
    O,O,O,O,S];

[estTR,estE] = hmmtrain(train,trans,emis);

% hmm score using yfit1mix
load('./tmp/yfit1mix.mat');
test=yfit1;

likelystates = hmmviterbi(train, estTR,estE);
figure 
plot(1:length(likelystates),likelystates);