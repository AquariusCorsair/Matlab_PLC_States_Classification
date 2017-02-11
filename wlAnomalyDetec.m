% wavelet changepoint detection 
load('tmp/score.mat');
NUM =15;
%'haar','dbN', 'fkN', 'coifN', or 'symN'
wt = modwt(score,'haar',NUM);
mra = modwtmra(wt,'haar');

figure;
for i=1:(NUM)
subplot(NUM,1,i)
plot(1:length(mra(i,:)),mra(i,:));
end
% 
figure
plot(1:length(score),score);
set(gca,'fontsize',14);
t1=xlabel('time(ms)');
t2=ylabel('Euclidean Distence');
t1.FontSize=16;
t2.FontSize=16;

winsize=500;
figure;
for i=1:(NUM)
    y=mra(i,:);
    M=zeros(length(y)-winsize,1);
    M_sum=zeros(length(y)-winsize,1);
    for j=1:(length(y)-winsize)
        M(j)=var(y(j:j+winsize));
    end
    subplot(NUM,1,i);
    plot(1:length(M),M);
    M_sum=M_sum+M;
end

% figure
% plot(1:length(M_sum),M_sum);
% title('var_sum')

% figure;
% for i=1:(NUM)
%     y=mra(i,:);
%     M=zeros(length(y)-winsize,1);
%     M_sum=zeros(length(y)-winsize,1);
%     for j=1:(length(y)-winsize)
%         M(j)=sum(y(j:j+winsize));
%     end
%     subplot(NUM,1,i);
%     plot(1:length(M),M);
%     M_sum=M_sum+M;
% end

% figure
% plot(1:length(M_sum),M_sum);
% title('mean_sum')

