# Channel_analysis
Custom Matlab script used to analyse channel width and depth of regular parralel channels. Written for the analysis of cellulose nanofiber microfluidic channels from 3d confocal microscope data presented in Brown et al (2022). 


## Contents 
detrend_2d_updated_210311.m - Main run file

Channel_analysis_210325.m - Function to remove linear drift in signal

Example.mat - Simple geometry


## Notes
Two manual checks are in place to ensure auto flattening and channel identification was effective.
4 Sensitivity variables (S1, S2, S3, S4) can be altered to assist in channel identification in non ideal samples.


## References
Christine Browne, Michael J. Hertaeg, David Joram Mendoza, Mahdi Naseri, Maoqi Lin, Gil Garnier, Warren Batchelor, Micropatterned cellulosic films to modulate paper wettability, Colloids and Surfaces A: Physicochemical and Engineering Aspects, Volume 656, Part A, 2023, 130379, URL: https://www.sciencedirect.com/science/article/abs/pii/S0927775722021343.

Munther (2021). flatten a data in 2D (https://www.mathworks.com/matlabcentral/fileexchange/33192-flatten-a-data-in-2d), MATLAB Central File Exchange. Retrieved May 31, 2021.




