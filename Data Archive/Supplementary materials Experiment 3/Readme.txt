-------------------
GENERAL INFORMATION
-------------------

1. Title: Experiment 3 for the supplementary materials of the MSc Thesis 'Neural Networks for Latent Budget Analysis of Compositional Data'

2. Author Information
    
    Name: Zhenwei Yang
    Institution: Utrecht University
    Address: Sjoerd Groenman building, Padualaan 14, 3584 CH, Utrecht, The
Netherlands
    Email: z.yang@uu.nl
	Phone Number: +31626358514



---------------------
DATA & FILE OVERVIEW
---------------------


Directory of Files:	"Data/"
   A. Filename:        data_3.csv
      Short description:        Example data 3, a previously-used German Suicide data regenerated by "1. generating data from constrained latent budget analysis.R" (See "Script/"). The data is regenerated from the contingency table in (Van der Heijden, Mooijaart, and De Leeuw 1992). In total, 53211 observations with two explanatory variables gender and age, and cause of death (response variable, with 9 categories).


        
   B. Filename:        testdata_3.csv
      Short description:        The test dataset for Example 3 (10000 observations)


        
   C. Filename:        traindata_3.csv
      Short description:	The training dataset for Example 3 (43211 observations)




Directory of Files:	"Script/"
   A. Filename:        1. generating data from constrained latent budget analysis.R
      Short description:        Regenerate the data from "constrained latent budget analysis" and store in "data_3.csv". And split into a training and a test set.

        

   B. Filename:        2. Example 3_LBA_NN.R
      Short description:        Implement LBA-NN on example 3. Can yield (in "Output/"): (1) figS1_importance_plot_example_3.png; (2) figS2_biplot_example_3.png; (3) figS3a_confusion_matrix_lbann.png; (4) tabS4_1_summary_prediction_lbann.csv


        
   C. Filename:        3. Example 3_LBA.R
      Short description:	Implement LBA on example 3. Can yield (in "Output/"): (1) tabS2_contingency_table_example3.csv; (2) tabS3_1_mixing parameters A.csv; (3) tabS3_2_latent budgets B.csv; (4) figS3b_confusion_matrix_lba.png; (5) tabS4_2_summary_prediction_lba.csv



   D. Filename:        4. function.R
      Short description:	Involved functions. (1) evm.test: generate the input data matrix; (2) rvm.test: generate output data matrix



   E. Foldername:	Supplementary materials_hyperparameter optimization
      Short description:	Used to choose the hyperparameters in LBA-NN. (1) hyperparameter optimization: optimize the hyperparameters automatically; (2) tuning setting: set up the model and initial hyperparameters




Directory of Files:	"Output/"
   A. Filename:        figS1_importance_plot_example_3.png
      Short description:        Figure S1: The importance plot from function "lbann" on example 3

        
   B. Filename:        figS2_biplot_example_3.png
      Short description:        Figure S2: The biplot from function "lbann" on example 3

        

   C. Filename:        figS3a_confusion_matrix_lbann.png
      Short description:	Figure S3a: The confusion matrix to evaluate the performance of LBA-NN



   D. Filename:        figS3b_confusion_matrix_lba.png
      Short description:	Figure S3b: The confusion matrix to evaluate the performance of LBA



   E. Filename:		tabS2_contingency_table_example3.csv
      Short description:	Table S2: The summary table for data_3.csv



   F. Filename: 	tabS3_1_mixing parameters A.csv
      Short description:	Table S3: The outputs of LBA on example 3 (the mixing parameters part)



   G. Filename: 	tabS3_2_latent budgets B.csv
      Short description:	Table S3: The outputs of LBA on example 3 (the latent budget parameters part)



   H. Filename: 	tabS4_1_summary_prediction_lbann.csv
      Short description:	Table S4: The summary of the performance of LBA-NN on example 3



   I. Filename: 	tabS4_2_summary_prediction_lba.csv
      Short description:	Table S4: The summary of the performance of LBA on example 3




--------------------------
METHODOLOGICAL INFORMATION
--------------------------

1. Software-specific information:

Name:	lbann
Version:	1.0
Software Requirements:	R
Open Source? (Y/N): 	Y

(if available and applicable)
Executable code:	devtools::install_github("https://github.com/ZhenweiYang96/lbann")
Source Repository URL:	https://github.com/ZhenweiYang96/lbann
Developer:	Zhenwei Yang