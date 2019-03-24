load('deepnet.mat','deepnet');
load('Train_label.mat');
load('Test_label.mat');
load('CSP_Train_feature.mat')
load('CSP_Test_feature.mat');
CSP_DNN_Train_data = CSP_Train_feature';
CSP_DNN_Test_data = CSP_Test_feature';
image_train_type = deepnet(CSP_DNN_Train_data);
image_test_type = deepnet(CSP_DNN_Test_data);
%%
% Plot the confusion matrix.
figure(1),plotconfusion(Train_label,image_train_type);
figure(2),plotconfusion(Test_label,image_test_type);