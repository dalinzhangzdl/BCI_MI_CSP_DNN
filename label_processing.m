clear all
clc
Data = load('graz_data\dataset_BCIcomp1.mat'); % 加载训练数据集
load('graz_data\labels_data_set_iii.mat');   % 加载测试数据集标签 y_test
trian_label = Data.y_train;
test_label = y_test;
s = length(trian_label);
train_output = zeros(s,2);
test_output = zeros(s,2);
for i = 1:s
    train_output(i,trian_label(i)) = 1; % label_data(i)的值为1或2
    test_output(i,test_label(i)) = 1;   % 同上
end
Train_label = train_output';
Test_label = test_output';
save('label.mat', 'Train_label','Test_label');