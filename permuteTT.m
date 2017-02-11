function [train,test] = permuteTT(cn,trainPercentage,dataFeature,label) % cn: class number
dfs=size(dataFeature);
num = dfs(1,1)/cn;

[en, fn] = size(dataFeature);%en: example number; fn: feature number

a = zeros(cn,1);
for i=1:length(label)
    k = label(i);
    a(k) = a(k)+1;
end

tt = zeros(1,num*cn);
pnt = 0;
for i=1:length(a)
    tt(pnt+1:pnt+a(i))=randperm(a(i));
    pnt = pnt+a(i);
end

thrainNum = int32(num*trainPercentage);
train = zeros(thrainNum,fn);
maxTestNum = num - thrainNum;
test = zeros(maxTestNum,fn);

i1=1;
i2=1;
for i = 1:en
    if tt(i)<=thrainNum
        train(i1,:) = dataFeature(i,:);
        i1 = i1+1;
    else
        test(i2,:) = dataFeature(i,:);
        i2 = i2+1;
    end
end
 disp(['train number: ' num2str(i1-1)]);
 disp(['test number: ' num2str(i2-1)]);




  
  
  
  
  
  