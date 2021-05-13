# Neural Networks for Latent Budget Analysis

This repository is for the Master's thesis 'Neural Networks for Latent Budget Analysis' by Zhenwei Yang. 

## Abstract

Compositional data are non-negative data collected in a rectangular matrix with a constant row sum. Due to the non-negativity the focus is on conditional proportions that add up to 1 for each row. A row of conditional proportions is called an observed budget. Latent budget analysis (LBA) assumes a mixture of latent budgets that explains the observed budgets. LBA is usually fitted to a contingency table, where the rows are levels of one or more explanatory variables and the columns the levels of a response variable. In prospective studies, there is only knowledge about the explanatory variables of individuals and interest goes out to predicting the response variable. Thus, a form of LBA is needed that has the functionality of prediction. Previous studies proposed a constrained neural network (NN) extension of LBA that was hampered by an unsatisfying prediction ability. Here we propose LBA-NN, a feed forward NN model that yields a similar interpretation to LBA but equips LBA with a better ability of prediction. A stable and plausible interpretation of LBA-NN is obtained through the use of importance plots and table, that show the relative importance of all explanatory variables on the response variable. An LBA-NN-K-means approach that applies K-means clustering on the importance table is used to produce K clusters that are comparable to K latent budgets in LBA. Here we provide different experiments where LBA-NN is implemented and compared with LBA. In our analysis, LBA-NN outperforms LBA in prediction in terms of accuracy, specificity, recall and mean square error. We provide open-source software at GitHub.

## Contents

The thesis report is named `MSc Thesis Z. Yang.pdf` and the supplementary materials are also attached, named as `Supplementary-materials.pdf`.

Besides, the repository contains two folders `Data Archive` and `report`. 

The former folder serves as a research archive where data and outputs for the three experiments are restored. In each of the three experiments there are three subfolders, namely:

- `Data` | Contains the (raw) data, training dataset, test dataset.
- `Script` | Contains the R scripts for preprocessing (or data generating), Implementation of LBA-NN on example, Implementation of LBA on example and involved functions. Additionally, there is also a folder, `Supplementary materials_hyperparameter optimization` which is used to find the optimal hyperparameter for LBA-NN.
- `Output` | Contains the yielded figures or tables that are used in the thesis, namely: contigency table, LBA outputs, importance plots, biplot, confusion matrices and summary of performance.

The latter folder is for compiling the thesis and supplementary materials based on the yielded figures and tables.

## Permission and access

The entire research archive is available through [https://github.com/ZhenweiYang96/MSc-Statistics-Thesis](https://github.com/ZhenweiYang96/MSc-Statistics-Thesis). The Github repository is public, and therefore completely 'open access'. The data will be stored for a minimal duration of ten years.

The R package `lbann` mentioned in the thesis can be find on [https://github.com/ZhenweiYang96/lbann](https://github.com/ZhenweiYang96/lbann). If you want to use that, please use the following code:
``library(devtools)
devtools::install_github("https://github.com/ZhenweiYang96/lbann")``
