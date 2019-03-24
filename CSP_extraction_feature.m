clc;
clear;
EEGSignals = load('graz_data/CSP_train.mat');   % 加载带通滤波后的脑电数据
%check and initializations
EEG_Channels = size(EEGSignals.x_train,2);
EEG_Trials = size(EEGSignals.x_train,3);
classLabels = unique(EEGSignals.y_train);% Return non-repeating values
EEG_Classes = length(classLabels);
covMatrix = cell(EEG_Classes,1); % 协方差矩阵
% Computing the normalized covariance matrices for each trial
trialCov = zeros(EEG_Channels,EEG_Channels,EEG_Trials);
for i = 1:EEG_Trials
    E = EEGSignals.x_train(:,:,i)';
    EE = E*E';
    trialCov(:,:,i) = EE./trace(EE);  % 计算协方差矩阵
end
clear E;
clear EE;
% 计算每一类样本数据的空间协方差之和
for i = 1:EEG_Classes
    covMatrix{i} = mean(trialCov(:,:,EEGSignals.y_train == classLabels(i)),3);
end
% 计算两类数据的空间协方差之和
covTotal = covMatrix{1} + covMatrix{2};
% 计算特征向量和特征矩阵
[Uc,Dt] = eig(covTotal);
% 特征值要降序排列
eigenvalues = diag(Dt);
[eigenvalues,egIndex] = sort(eigenvalues, 'descend');% 降序
Ut = Uc(:,egIndex);
% 矩阵白化
P = diag(sqrt(1./eigenvalues))*Ut';
% 矩阵P作用求公共特征向量transformedCov1 
transformedCov1 = P*covMatrix{1}*P';
%计算公共特征向量transformedCov1的特征向量和特征矩阵
[U1,D1] = eig(transformedCov1);
eigenvalues = diag(D1);
[eigenvalues,egIndex] = sort(eigenvalues, 'descend');% 降序排列
U1 = U1(:, egIndex);
% 计算投影矩阵W
CSPMatrix = U1' * P;
% 计算特征矩阵
FilterPairs = 2;       % CSP特征选择参数m    CSP特征为2*m个
features_train = zeros(EEG_Trials, 2*FilterPairs+1);
features_test = zeros(EEG_Trials, 2*FilterPairs+1);
Filter = CSPMatrix([1:FilterPairs (end-FilterPairs+1):end],:);
%extracting the CSP features from each trial
for t=1:EEG_Trials    
    %projecting the data onto the CSP filters    
    projectedTrial_train = Filter * EEGSignals.x_train(:,:,t)';    
    projectedTrial_test = Filter * EEGSignals.x_test(:,:,t)';
    %generating the features as the log variance of the projected signals
    variances_train = var(projectedTrial_train,0,2);  
    variances_test = var(projectedTrial_test,0,2);
    for f=1:length(variances_train)
        features_train(t,f) = log(variances_train(f));
    end
    for f=1:length(variances_test)
        features_test(t,f) = log(variances_test(f));
    end
end
CSP_Train_feature = features_train(:,1:4);
CSP_Test_feature = features_test(:,1:4);
save('CSP_feature.mat','CSP_Train_feature','CSP_Test_feature');










