# Channel_analysis
Custom Matlab script used to analyse used to analyse channel width and depth of regular parralel channels. Written for the analysis of cellulose nanofiber microfluidic channels from 3d confocal microscope data presented in (Submitted).


## Contents 
run.m - Calles all funtions in order

measure_distance.m - Function measures distance of each void space voxel to the nearest solid phase voxel

fill_spheres.m - Function places spheres of specified dimentions into void space

example_geom.mat - Simple 3D geometry for demonstration


## Code Walkthrough
The first step is completed in the function 'measure_distance' where every voxel in the void space is assigned a number that corresponds to the distance to the closest solid phase voxel. The output of this step is saved as 'radius_map.mat' and is passed onto the 'fill_spheres' function which fills the void space with spheres of the specified radius. The output of this function is saved as zones, this is a 3D matrix where the value of each entry is dependant on the phase ocupying that voxel. 0 - non wetting phase, 1 - wetting phase and 2 - solid phase. Example 2D slices of this matrix are displayed for each specified radius.

## Notes
For large images the use of parralel for loops (parfor) decreases solving time significantly


## References

Hazlett, R. D. Transport in Porous Media 1995, 20, 21–35. 

Masoodi, Reza, and Krishna M. Pillai, eds. Wicking in porous materials: traditional and modern modeling approaches. CRC Press, 2012 p 136-140.



