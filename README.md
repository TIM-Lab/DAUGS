# DAUGS

## Abstract

Fully automatic analysis of first-pass myocardial perfusion MRI datasets enables rapid and objective reporting of stress/rest studies in patients with suspected ischemia. In the context of A.I.-based approaches, developing deep learning techniques that, despite having a limited training dataset, are capable of analyzing multi-center datasets with dissimilarities in software (pulse sequence) and hardware (scanner vendor) is an ongoing challenge. 

In this work, we employed a space-time sliding-patch analysis approach that automatically yields a pixel-wise "uncertainty map" as a byproduct of the segmentation process. In our approach, dubbed *Data-adaptive Uncertainty-guided Space-time (DAUGS) analysis*, the output of all members of the DNN pool are computed and the accompanying uncertainty maps are leveraged to automatically choose the “best” result.

## Overview

<img width="1491" alt="Screen Shot 2023-06-09 at 12 36 56 PM" src="https://github.com/TIM-Lab/DAUGS/assets/42877335/e4e90fb6-6192-4876-8457-3bf67c905015">

**Figure 1.** Description of the proposed data-adaptive uncertainty-guided space-time (DAUGS) analysis. The internal dataset was split into three subsets (training data, validation data, and the internal test set). Next, hyperparameter selection (learning rate, model parameters, patch and sliding window size, etc.) was performed by evaluating the performance on the validation data. **Steps 1 & 2:** All models were trained using a patch-level approach and a pool of trained DNN models was obtained by varying the DNN parameter initializations in the training process. **Step 3:** At test time, each model in the DNN pool provides a segmentation result (endo/epi contours) and a pixel-wise uncertainty map (U-map) thanks to sliding space-time patch-level analysis approach. **Step 4:** By computing the total per-pixel energy of the U-maps (denoted as Upp) our proposed data-adaptive approach selects the segmentation result with the lowest Upp (hence, lowest per-pixel uncertainty) as the “best” segmentation.

## Code

This repository provides the code to perform the following on a representative myocardial perfusion image series:

- Patch decompostion and combination steps for patch-level segmentation and uncertainty map generation as a byproduct
- Choosing the model from a representative model pool with the lowest uncertainty as part of DAUGS analysis for robust segmentation of myocardial segmentation datasets


### Contact
Dilek M. Yalcinkaya (dyalcink@purdue.edu)
