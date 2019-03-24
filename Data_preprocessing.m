clc;
clear;
EEGSignals = load('graz_data/dataset_BCIcomp1.mat');
%check and initializations
EEG_Channels = size(EEGSignals.x_train,2);
EEG_Trials = size(EEGSignals.x_train,3);
for i = 1:EEG_Trials
    for j = 1:EEG_Channels
        x_train(:,j,i) = filter(Bandpass_filter,EEGSignals.x_train(513:768,j,i));
        x_test(:,j,i) = filter(Bandpass_filter,EEGSignals.x_test(513:768,j,i));
    end
    y_train(i,:) = EEGSignals.y_train(i,:);
end
save('graz_data/CSP_train.mat','x_train','y_train','x_test');
