%% test
% plot the predicted class and true class using a trained model 
% output the confusion matrix
function acc = testClassifier(test,Model)
%% ============== Part one : predict using given Model ==================
len=size(test);
[yfit,score] = Model.predictFcn(test(:,2:len(2)));

% figure
% plot(1:length(score),score);
% title('score for testing data');

% plot the result if needed
if 0
    figure
    plot(1:length(yfit),yfit,'b.');
    hold on
    plot(1:length(test(:,1)),test(:,1),'y--');
    title('result of prediced data and true data');
    xlabel('test data index');
    ylabel('class Index');
    legend('prediced','true','Location','northwest')
end
%% ============= Part two : calculate confusion matrix ==========
g1 = test(:,1);		% Known groups
g2 = yfit';	% Predicted groups

[C,order] = confusionmat(g1,g2);
save('./tmp/confusionMatrixTest.mat','C');
sumAll = sum(sum(C));
sumEye = sum(sum(C.*eye(size(C))));
disp(['error number = ', num2str(sumAll-sumEye)]);
acc = sumEye/sumAll;