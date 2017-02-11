function dtwM = generateDtwModel(stateTran, periodNumPerTest)
stateTran = [4;5;1;4;5;1;3;2;1;3;2;1];
disp(['there are '  num2str(periodNumPerTest) 'periods in the testing.wav']);

dtwM=ones(length(stateTran),periodNumPerTest);
for i=1:periodNumPerTest
    dtwM(:,i) = stateTran;
end
dtwM=dtwM(:);
