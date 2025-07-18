Segments the white matter hyperintensities and classify by regions.

Based on wmh_seg (https://github.com/jinghangli98/wmh_seg) and Freesurfer.

Citation for wmh_seg: Li, J., Santini, T., Huang, Y., Mettenburg, J. M., Ibrahim, T. S., Aizenstein, H. J., & Wu, M. (2024). wmh_seg: Transformer based U-Net for Robust and Automatic White Matter Hyperintensity Segmentation across 1.5 T, 3T and 7T. arXiv preprint arXiv:2402.12701.

Example of usage with the test data:

`docker run -v $PWD:/data -w /data tsantini/wmh_seg:regions wmh_regional_seg --t1w sample_t1w.nii.gz --flair sample_flair.nii.gz`
