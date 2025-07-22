# Purpose
Segment FLAIR-white matter hyperintensities (WMHs) and classify them by white matter regions.

Use [wmh_seg](https://github.com/jinghangli98/wmh_seg) in FLAIR images and [Freesurfer](https://surfer.nmr.mgh.harvard.edu/) in T1w images to reveal WMH spatial pattern in your dataset.

# How to use it

Usage:

```
wmh_regional_seg --t1w FILE --flair FILE [--no-full]

Required arguments:
  --t1w FILE         Path to the T1-weighted NIfTI image
  --flair FILE       Path to the FLAIR NIfTI image

Optional arguments:
  --no-full          Skip WMH_seg and FreeSurfer segmentation (useful for manually corrected segmentations)
  -h, --help         Show this help message
```

Example of usage with the test data:

`docker run -v $PWD:/data -w /data tsantini/wmh_seg:regions wmh_regional_seg --t1w sample_t1w.nii.gz --flair sample_flair.nii.gz`

Example of usage after running the test data but manually correcting the wmg_seg file (this skips all the processing):

`docker run -v $PWD:/data -w /data tsantini/wmh_seg:regions wmh_regional_seg --t1w sample_t1w.nii.gz --flair sample_flair.nii.gz --no-full`

Example of usage if you want o run the wmg_seg only (much faster):

`docker run -v $PWD:/data -w /data tsantini/wmh_seg:regions wmh_seg -i sample_flair.nii.gz -o sample_flair_wmh_seg.nii.gz`

The label code can be found [here](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/AnatomicalROI/FreeSurferColorLUT).

# Qualitative outcome

<img width="360" height="323" alt="snapshot0001" src="https://github.com/user-attachments/assets/99c07a51-7d74-4fbd-84fc-53e3f392fbd0" />
<img width="360" height="323" alt="snapshot0002" src="https://github.com/user-attachments/assets/804ea4b2-626c-49a0-ace7-5a7d6713ef57" />

# Quantitative outcome

Use label codes below to generate WMH volumes in frontal, cingulate, occipital, temporal, parietal, and insula lobes in left and right hemispheres: 
```
3201    wm-lh-frontal-lobe                  235 35  95  0
3203    wm-lh-cingulate-lobe                35  75  35  0
3204    wm-lh-occiptal-lobe                 135 155 195 0
3205    wm-lh-temporal-lobe                 115 35  35  0
3206    wm-lh-parietal-lobe                 35  195 35  0
3207    wm-lh-insula-lobe                   20  220 160 0

4201    wm-rh-frontal-lobe                  235 35  95  0
4203    wm-rh-cingulate-lobe                35  75  35  0
4204    wm-rh-occiptal-lobe                 135 155 195 0
4205    wm-rh-temporal-lobe                 115 35  35  0
4206    wm-rh-parietal-lobe                 35  195 35  0
4207    wm-rh-insula-lobe                   20  220 160 0
```
This is similar to the voxel-wise analysis used in [Phuah et al. 2022](https://pmc.ncbi.nlm.nih.gov/articles/PMC9754646/) and mentioned in [Botz et al. 2023](https://pmc.ncbi.nlm.nih.gov/articles/PMC10214839/)
# Citation
Li, J., Santini, T., Huang, Y., Mettenburg, J. M., Ibrahim, T. S., Aizenstein, H. J., & Wu, M. (2024). [wmh_seg: Transformer based U-Net for Robust and Automatic White Matter Hyperintensity Segmentation across 1.5 T, 3T and 7T](https://arxiv.org/abs/2402.12701). arXiv preprint arXiv:2402.12701. 
