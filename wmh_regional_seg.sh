#!/bin/bash

set -e  # Exit on error

# ---------- Default Parameters ----------
TMP_DIR="/tmp/wmh_regional_seg"
SUBJECT_DIR="$TMP_DIR"
mkdir -p "$TMP_DIR"
run_full_pipeline=1

# ---------- Help Function ----------
print_help() {
  echo "Usage: $0 --t1w FILE --flair FILE [--no-full]"
  echo
  echo "Required arguments:"
  echo "  --t1w FILE         Path to the T1-weighted NIfTI image"
  echo "  --flair FILE       Path to the FLAIR NIfTI image"
  echo
  echo "Optional arguments:"
  echo "  --no-full          Skip WMH_seg and FreeSurfer segmentation (useful for manually corrected segmentations)"
  echo "  -h, --help         Show this help message"
  echo
  exit 0
}

# ---------- Parse Arguments ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --t1w)
      t1w="$2"
      shift 2
      ;;
    --flair)
      flair="$2"
      shift 2
      ;;
    --no-full)
      run_full_pipeline=0
      shift
      ;;
    -h|--help)
      print_help
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h for help."
      exit 1
      ;;
  esac
done

# ---------- Validate Inputs ----------
if [[ -z "$t1w" || -z "$flair" ]]; then
  echo "Error: --t1w and --flair are required."
  echo "Use -h for help."
  exit 1
fi

# Basenames for intermediate files
t1w_base=$(basename "${t1w%.nii.gz}")
flair_base=$(basename "${flair%.nii.gz}")

# ---------- Main Pipeline ----------
if [[ $run_full_pipeline -eq 1 ]]; then
  echo "Segmenting the WMHs..."
  wmh_seg -i "$flair" -o "$TMP_DIR/${flair_base}_wmh_seg.nii.gz"

  echo "Segmenting the White Matter..."
  recon-all -all -i "$t1w" -subjid "$t1w_base" -cm -sd "$SUBJECT_DIR"

  echo "Registering T1w and FLAIR..."
  mri_robust_register \
    --mov "$SUBJECT_DIR/$t1w_base/mri/T1.mgz" \
    --dst "$flair" \
    --lta "$TMP_DIR/T1w_to_FLAIR.lta" \
    --iscale --satit

  mri_vol2vol \
    --mov "$SUBJECT_DIR/$t1w_base/mri/wmparc.mgz" \
    --targ "$flair" \
    --lta "$TMP_DIR/T1w_to_FLAIR.lta" \
    --o "$TMP_DIR/wmparc_flair.nii.gz" \
    --interp nearest
fi

echo "Applying regional WMHs..."
mris_calc \
  --output "${flair_base}_wmh_regional_seg.nii.gz" \
  "$TMP_DIR/${flair_base}_wmh_seg.nii.gz" \
  mul "$TMP_DIR/wmparc_flair.nii.gz"

# keep a copy of the WMH segmentation in the output directory
cp "$TMP_DIR/${flair_base}_wmh_seg.nii.gz" "${flair_base}_wmh_seg.nii.gz"

