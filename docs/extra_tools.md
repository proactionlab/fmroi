Extra Tools
============
The extra tools offer a range of additional functions that, while not crucial to the core functionality of fMROI, can be highly beneficial for various tasks. These tools can be found in the "Tools" menu. By default, fMROI 1.0.x includes a screenshot assistant that enables automated capture of multiple slices and the creation of image mosaics. Additionally, fMROI features an import assistant in the "Config" menu to simplify the integration of new tools. The files for these extra tools are stored in the "tools" folder within the fMROI root directory.

Applymask
----------

Applymask (or runapplymask for command line use) function applies masks to a set of source images, extracting time-series data and statistical measures from these masked regions, and saving the results to a specified output directory.

- **Syntax:**
    - *runapplymask(srcpath,maskpath,outdir,opts,hObject)*

- **Inputs:**
    - **srcpath:** String containg the paths to the source images separeted by semicolons, or a path to a text file (.txt, .csv, or .tsv) containing the images paths in a line (separated by tabs or semicolons) or in a column (1D array).
    - **maskpath:** String containg the paths to the mask images separeted by semicolons, or a path to a text file (.txt, .csv, or .tsv) containing the maskpaths paths separated by tabs orsemicolons. The number of mask paths must exactly match the number of source images or there can be only one mask. Each mask in the list is applied to the corresponding source image in the same order (i.e., first mask to first image, second mask to second image, and so on). If the maskpath points to a text file, each column represents a different mask type and will be processed separately. Each column can have as many lines as there are source images or only one mask to be applied to all images.
    - **outdir:** Path to the output directory (string).
    - **opts:** (optional) A structure containing options for saving outputs.
        - *opts.saveimg:* (default: 1) Flag indicating if masked images should be saved (logical, 1 to save, 0 to not save).
        - *opts.savestats:* (default: 1) Flag indicating if statistics should be saved (logical, 1 to save, 0 to not save).
        - *opts.savets:* (default: 1) Flag indicating if time series data should be saved (logical, 1 to save, 0 to not save).
        - *opts.groupts:* (default: 0) Flag used to control how the time series data is saved. If opts.groupts is set to 1, then thetime series data will be saved grouped by source image. This means that all of the masks for a particular source image will be saved together in a single file. However, if opts.groupts is set to 0, then the time series data will be saved for each mask separately. This means that there will be a separate file for each mask.
    - **hObject:** (Optional - default: NaN) Handle to the graphical user interface object. Not provided for command line usage.

 - **Outputs:** runapplymask saves to the output directory the following data:
    - Masked images (if opts.saveimg is set to 1).
    - Timeseries.mat file containing the source paths, mask paths, and time series data (if opts.savets is set to 1).
    - Median.csv, Mean.csv, Std.csv, Max.csv, Min.csv files containing statistics for each mask applied to each source image (if opts.savestats is set to 1).

*This function requires SPM 12 to be installed.*

Connectome
-----------
 Connectome (or runconnectome for command line use) computes Pearson correlation coefficients, p-values, and Fisher transformation connectomes from input time-series data and saves the results in specified output directories. Optionally, it can save the results as feature matrices for machine-learning use.


- **Inputs:**
    - **tspath:** Path(s) to the time-series data file(s). Supported formats are .mat, .txt, .csv, and .tsv. For .mat files, the data can be a table, cell array, or numeric array:
        - If a Matlab table, it must have a variable named as "timeseries" from where the time-series are extracted and stored in a cell array. Time-series within each cell is processed separately, resulting in as many connectomes as the number of cells. It is possible to obtain this table directly from the applymask algorithm (fmroi/tools).
        - If a cell array, each time-series within each cell is processed separately, resulting in as many connectomes as the number of cells.
        - If a numeric array (matrix) or any other file type, a single connectome is generated for all the time-series, treating them as from the same subject.
    - **outdir:** Directory where the output files will be saved.
    - **roinamespath:** (Optional) Path to the file containing ROI names. Supported formats are .mat, .txt, .csv, and .tsv. The file must have the same length as the number of time-series. Each ROI name in roinamespath corresponds to the ROI from which each time-series was extracted.
                 If not provided, generic names will be assigned.
    - **opts:** (Optional - default: 1) Structure containing options:
        - opts.rsave: Save Pearson correlation connectome.
        - opts.psave: Save p-values connectome.
        - opts.zsave: Save Fisher transformation connectome.
        - opts.ftsave: Save feature matrices. 
    - **hObject:** (Optional - default: NaN) Handle to the graphical user 
                 interface object. Not provided for command line usage.

- **Outputs:**
    - The runconnectome saves the computed connectomes and feature matrices in the specified output directory. The filenames include 'rconnec.mat', 'pconnec.mat', 'zconnec.mat', and their corresponding feature matrices as 'rfeatmat.mat', 'pfeatmat.mat', 'zfeatmat.mat', and their CSV versions.