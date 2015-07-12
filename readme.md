#Poission Editing

###Importing gradients
<img src="https://github.com/mincongzhang/PoissionEditing/raw/master/ImportGrad.bmp" width="600" align="middle"/>

###Mixing gradients
<img src="https://github.com/mincongzhang/PoissionEditing/raw/master/MixingGrad.bmp" width="600" align="middle"/>

1.  Script "RegionR.m" performs the method to "Remove the selected region R and fill it in using the Equation (2) in the paper". This script is adapted from the function of importing gradient because there is no big difference between them.

2. For testing and fast calculation, I write a script for importing gradients in rectangle region. Just run the "editing_script.m" in folder "Importing_gradients_rectangle_region"

3. For running importing gradients in arbtrary region, open the folder "Importing_gradients_arbitrary_region" and run script "editing_script_RGB.m"

4. For running mixing gradients, open the folder "Mixing_gradients" and run script "editing_script_RGB.m"

###### Reference  
1. *Pérez, Patrick, Michel Gangnet, and Andrew Blake. "Poisson image editing." ACM Transactions on Graphics (TOG). Vol. 22. No. 3. ACM, 2003.
