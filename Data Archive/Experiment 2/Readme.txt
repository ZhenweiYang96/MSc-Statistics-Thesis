-------------------
GENERAL INFORMATION
-------------------

1. Title: Experiment 2 for the MSc Thesis 'Neural Networks for Latent Budget Analysis of Compositional Data'

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
   A. Filename:        data_2.csv
      Short description:        Example data 2, a public LED data preprocessed by 1. Preprocessing led data.R (See "Script/"). In total, 500 observations with seven binary variables V1 - V7 (only V1 - V5 are used in this study), Class (the response variable, led classes with 10 categories).



   B. Filename:        phpSj3fWL.csv
      Short description:        The raw data downloaded from https://www.openml.org/d/40496


        
   C. Filename:        testdata_2.csv
      Short description:        The test dataset from Example 2 (100 observations)


        
   D. Filename:        traindata_2.csv
      Short description:	The training dataset from Example 1 (400 observations)




Directory of Files:	"Script/"
   A. Filename:        1. Preprocessing led data.R
      Short description:        Preprocess the raw Example data 2 ("phpSj3fWL.csv") and yield "data_2.csv"

        
   B. Filename:        2. Example 2_LBA_NN.R
      Short description:        Implement LBA-NN on example 2. Can yield (in "Output/"): (1) fig6_importance_plot_example_2.png; (2) fig7_biplot_example_2.png; (3) fig8a_confusion_matrix_lbann.png; (4) tab8_1_summary_prediction_lbann.csv


        
   C. Filename:        3. Example 2_LBA.R
      Short description:	Implement LBA-NN on example 2. Can yield (in "Output/"): (1) tab6_contingency_table_example2.csv; (2) tab7_1_mixing parameters A.csv; (3) tab7_2_latent budgets B.csv; (4) fig8b_confusion_matrix_lba.png; (5) tab8_2_summary_prediction_lba.csv



   D. Filename:        4. function.R
      Short description:	Involved functions. (1) evm.test: generate the input data matrix; (2) rvm.test: generate output data matrix



   E. Foldername:	Supplementary materials_hyperparameter optimization
      Short description:	Used to choose the hyperparameters in LBA-NN. (1) hyperparameter optimization: optimize the hyperparameters automatically; (2) tuning setting: set up the model and initial hyperparameters




Directory of Files:	"Output/"
   A. Filename:        fig6_importance_plot_example_2.png
      Short description:        Figure 6: The importance plot from function "lbann" on example 2

        
   B. Filename:        fig7_biplot_example_2.png
      Short description:        Figure 7: The biplot from function "lbann" on example 2

        

   C. Filename:        fig8a_confusion_matrix_lbann.png
      Short description:	Figure 8a: The confusion matrix to evaluate the performance of LBA-NN



   D. Filename:        fig8b_confusion_matrix_lba.png
      Short description:	Figure 8b: The confusion matrix to evaluate the performance of LBA



   E. Filename:		tab6_contingency_table_example2.csv
      Short description:	Table 6: The summary table for "data_2.csv"




   F. Filename: 	tab7_1_mixing parameters A.csv
      Short description:	Table 7: The outputs of LBA on example 2 (the mixing parameters part)



   G. Filename: 	tab7_2_latent budgets B.csv
      Short description:	Table 7: The outputs of LBA on example 2 (the latent budget parameters part)



   H. Filename: 	tab8_1_summary_prediction_lbann.csv
      Short description:	Table 8: The summary of the performance of LBA-NN on example 2



   I. Filename: 	tab8_2_summary_prediction_lba.csv
      Short description:	Table 8: The summary of the performance of LBA on example 2




--------------------------
METHODOLOGICAL INFORMATION
--------------------------

1. Software-specific information:

Name:	lbann
Version:	1.0
System Requirements:	R
Open Source? (Y/N): 	Y

(if available and applicable)
Executable code:	devtools::install_github("https://github.com/ZhenweiYang96/lbann")
Source Repository URL:	https://github.com/ZhenweiYang96/lbann
Developer:	Zhenwei Yang