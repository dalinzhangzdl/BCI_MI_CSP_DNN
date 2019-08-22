%% Construct Deep Network Using Autoencoders
% CSP-DNN
clc;
clear;
% Load the sample data.
load('CSP_feature.mat')
load('label.mat')
CSP_DNN_Train_data = CSP_Train_feature';
CSP_DNN_Test_data = CSP_Test_feature';
X = CSP_DNN_Train_data;
T = Train_label;
%%
% Train an autoencoder with a hidden layer of size 15 and a linear transfer
hiddenSize = 15;
autoenc1 = trainAutoencoder(X,hiddenSize,...
    'L2WeightRegularization',0.001,...
    'SparsityRegularization',4,...
    'SparsityProportion',0.05,...
    'DecoderTransferFunction','purelin',...
     'MaxEpochs', 1000);
 view(autoenc1);
 plotWeights(autoenc1);
%%
% Extract the features in the hidden layer.
features1 = encode(autoenc1,X);
%%
% Train a second autoencoder using the features from the first autoencoder. Do not scale the data.
hiddenSize = 3;
autoenc2 = trainAutoencoder(features1,hiddenSize,...
    'L2WeightRegularization',0.0005,...
    'SparsityRegularization',4,...
    'SparsityProportion',0.05,...
    'DecoderTransferFunction','purelin',...
    'ScaleData',false,...
    'MaxEpochs', 1000);
 view(autoenc2)
%%
% Extract the features in the hidden layer.
features2 = encode(autoenc2,features1);
%%
% Train a softmax layer for classification using the features, |features2|,
% from the second autoencoder, |autoenc2|.
softnet = trainSoftmaxLayer(features2,T,'LossFunction','crossentropy');
%%
% Stack the encoders and the softmax layer to form a deep network.
deepnet = stack(autoenc1,autoenc2,softnet);
%%
% Train the deep network on the CSP-EEG data.
epoches = 1;
for i = 1:epoches
    deepnet = train(deepnet,X,T);
end
% save('deepnet');
%%
image_type = deepnet(X);
image_test_type = deepnet(CSP_DNN_Test_data);
%%
% Plot the confusion matrix.
figure(1),plotconfusion(Train_label,image_type,'Train ');
figure(2),plotconfusion(Test_label,image_test_type,'Test ');
