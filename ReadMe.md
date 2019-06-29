# BCI_MI_CSP_DNN

-----------

## Introduction
* Please fellow the lisense of rasmusbergpal when use this program.<br>
* BCI_MI_CSP_DNN is a matlab progam for the classification Motor Imagery EEG signals.<br>
* BCI_MI_CSP_DNN programed based on matlab deep learning Toolbox
* The theory of this program based on CSP and DNN algorithm
* This performance of this program is based on BCI Competioion II dataset III [click here for more information](http://www.bbci.de/competition/ii/). <br>
  
> In this study, our goal was to use deep learning methods to improve the classification performance of motor imagery EEG signals. 
Therefore, we propose a classification method based on deep learning for motor imagery EEG signals. Based on the pre-processed raw
EEG signals, a co-space model (CSP) method is used to extract the EEG feature matrix, which is then fed to a deep neural network 
(DNN) for training and classification. Our work was tested experimentally on the BCI Competition II Dataset III dataset, and the 
best DNN framework was proposed, achieving an accuracy of 83.6%.<br>

----------------

## Notice
* Bandpass_filter.m              Bandpass fliter with frequency 10-12Hz<br>
* Data_preprocessing.m           EEG data preprocessing<br>
* CSP_extraction_feature.m       Extra CSP features<br>
* DNN.m                          Train and test the CSP-DNN network  <br>
* Four_layer_BPNN.m              The four - layer BP network was compared <br>
* graz_data                      BCI Competition2003 Dataset III. EEG datasets <br>
 
---------------
