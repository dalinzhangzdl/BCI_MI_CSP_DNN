clear;
clc;
% data load
load('CSP_feature.mat')
load('label.mat')
Train_data = CSP_Train_feature'; % ¹éÒ»»¯Êý¾Ý
Test_data = CSP_Test_feature';

% Train_label = Train_label';
% creat network
net = newff(minmax(Train_data),[15,3,2],{'tansig','tansig','purelin'},'traingdx');

% set train parameter
net.trainparam.show = 50;
net.trainparam.goal = 0.000002;
net.trainparam.lr = 0.015;
net.trainparam.epochs = 5000;

% start train
epochs = 2;
for i = 1:epochs
    net = train( net,Train_data,Train_label);
end
load('graz_data\labels_data_set_iii.mat')
test_Output = y_test;
Y = sim(net, Test_data);
Y = Y';
% test 
[s1, s2] = size(Y);
hitNum = 0;
for i = 1:s1
    [m, index] = max(Y(i, :));
    if (index == test_Output(i))
        hitNum = hitNum + 1;
    end
end
sprintf('classification accuarcy %3.3f%%',100 * hitNum / s1 )


    
    
