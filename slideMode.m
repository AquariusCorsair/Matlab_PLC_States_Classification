load('./tmp/yfit1mix.mat');
winsize=200;
M=zeros(length(yfit1)-winsize,1);
for i=1:(length(yfit1)-winsize)
M(i,1)=mode(yfit1(i:i+winsize,1));
end
xlin=linspace(1,50,length(M));
figure,plot(xlin,M);
t1=xlabel('time/s');
t2=ylabel('Program States');
t1.FontSize=16;
t2.FontSize=16;
ylim([0,4]);