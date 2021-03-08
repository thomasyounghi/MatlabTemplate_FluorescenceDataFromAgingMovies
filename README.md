#MatlabTemplate_FluorescenceDataFromAgingMovies

These scripts were used to extract fluorescent data from yeast cells trapped at specific locations in a microfluidic device for a replicative lifespan study. The type of experiment they work for is one where an aging movie is divided in two parts. The first part consists of phaseg measurements only. This is followed by a second part consisting of snapshots of the same locations as the first part, but with additional fluorescent channels measured.

## The scripts accomplish the following:
1. Measuring fluorescence in the cells of interest in a trap
2. Facilitating measurement of background region in a local area among each cell of interest.
3. Facilitating circling of trapped cells of interest when they are not in the center of the trap.
4. Facilitating measurment of neighbor cells close to the trapped cell that may influence measurement of the fluorescent signal.

## The analysis workflow:

First, use microscope software to align images in part2 of the aging movie by phaseg features. This corrects for movement of the imaging area/trapped cells over the course of the movie.  Therefore, a mask applied to a given area at the first time point of the aligned movie, will still match to the same area at a later time point.  The tifs for the aligned movies should be saved in './tifs/'

The 'phaseg-only' part of the aging movie (part 1) should be exported as tifs to './phasegt1/'

fluorescence_processing.m part1: identify the locations of traps in the first phaseg image of the first part of the aging movie. Generates binary masks for the a polygonal region within the area that cells are typically trapped in within each trap. These are saved in './masks/mask_xy__.tif'

alignmasks.m : For each xy location, aligns the first phaseg image of part1 to the first phaseg image of part2.  Applies the corresponding transformation to the binary masks generated in fluorescence_processing.m part 1 to generate aligned binary masks. They are saved in './masks/maskal_xy__.tif'

fluorescence_processing.m part2: Applies the aligned binary masks './masks/mask_xy__.tif' to part2 of the aging movie. Extracts channel c2 and c3 fluorescence from each rectangular region in each trap, for all times in part2 of the aging movie. Results saved in 'rfprois.csv' and 'yfprois.csv'

trapbgdrawer.fig and trapbgdrawer.m: These define a gui that allows a user to semi-automatically place a rectangular background around a trap of interest. The user semi-automatically excludes any pixel within the rectangle that corresponds to cellular debris, or trap structures. A binary mask corresponding to the excluded areas of each rectangle is saved in './manualbgmasks/notbg_t_xy__.tif'. Binary masks corresponding to the rectangles are saved in './manualbgmasks/rect_t_xy_.tif'.  The non-excluded areas are used to measure background fluorescence.  The user must supply a csv file of xy locations and traps to apply this procedure to.

measuringlocalbg__.m: This extracts background fluorescence using the output of trapbgdrawer.m. Mean fluorescence in the specified channels are extracted for each non-excluded (background) region in the background rectangle surrounding a specified trap. This operation is performed across many time points, for which there can be changes in the excluded region (due to movement of cells in the image).

drawroipolygons.fig and drawroipolygons.m: These define a gui that allows a user to draw and save polygonal regions for images at different xy locations and time points. The user must supply a csv file of xy locations and traps to consider.  This was used to manually record positions of potentially bright neighboring cells to the trapped cells of interest. The results should be saved in a .mat file. They are annotated with time, xy location, and trap of interest. In this example these are 'neighborcellcoord_8_30_18_yTY146a.mat' and 'neighborcellcoord_8_30_18_yTY147a.mat'.

neighborcell_extraction_strainname.m: This extracts background fluorescence using the output of drawroipolygons.m.  For each roipolygon in the .mat file, extract mean fluorescence for channels c2 and c3 at the specified time and image. Saves the result in a .csv file.  This neighboring cell fluorescence data is used to determine when there is a bright cell neighboring the trap of interest.



