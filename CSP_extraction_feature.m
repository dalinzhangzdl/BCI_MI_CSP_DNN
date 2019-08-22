clc;
clear;
EEGSignals = load('graz_data/CSP_train.mat');   % load the filtered EEG data 
%check and initializations
EEG_Channels = size(EEGSignals.x_train,2);
EEG_Trials = size(EEGSignals.x_train,3);
classLabels = unique(EEGSignals.y_train);% Return non-repeating values
EEG_Classes = length(classLabels);
covMatrix = cell(EEG_Classes,1); % covariance matrix
% Computing the normalized covariance matrices for each trial
trialCov = zeros(EEG_Channels,EEG_Channels,EEG_Trials);
for i = 1:EEG_Trials
    E = EEGSignals.x_train(:,:,i)';
    EE = E*E';
    trialCov(:,:,i) = EE./trace(EE);  % compute covariance matrix
end
clear E;
clear EE;
% Calculate the sum of the spatial covariances for each class of sample data
for i = 1:EEG_Classes
    covMatrix{i} = mean(trialCov(:,:,EEGSignals.y_train == classLabels(i)),3);
end
% Calculate the sum of the spatial covariances of the two types of data
covTotal = covMatrix{1} + covMatrix{2};
% Calculate eigenvectors and eigenmatrices
[Uc,Dt] = eig(covTotal);
% Descending order of eigenvalues
eigenvalues = diag(Dt);
[eigenvalues,egIndex] = sort(eigenvalues, 'descend');% descend
Ut = Uc(:,egIndex);
P = diag(sqrt(1./eigenvalues))*Ut';
% common eigenvector transformedCov1 
transformedCov1 = P*covMatrix{1}*P';
% Calculate eigenvectors and eigenmatrices
[U1,D1] = eig(transformedCov1);
eigenvalues = diag(D1);
[eigenvalues,egIndex] = sort(eigenvalues, 'descend');% descend order
U1 = U1(:, egIndex);
% Calculate the projection matrix W
CSPMatrix = U1' * P;
% EEG feature matrix
FilterPairs = 2;       % CSP feature selection parameter m    the number of CSP feature is 2*m
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










