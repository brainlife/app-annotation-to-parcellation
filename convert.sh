#!/bin/bash

left=`jq -r '.left' config.json`
right=`jq -r '.right' config.json`
fsaverage=`jq -r '.fsaverage' config.json`

hemispheres='lh rh'

fsaverage=./templates/${fsaverage}

[ ! -d fsaverage ] && cp -R ${fsaverage} ./fsaverage

export SUBJECTS_DIR=./

[ ! -d parcellation ] && mkdir parcellation
[ ! -d raw ] && mkdir raw

# convert annot to volume parcellation
for hemi in ${hemispheres}
do
	if [[ ${hemi} == 'lh' ]]; then
		annot_data=${left}
	else
		annot_data=${right}
	fi

	[ ! -f ./${hemi}.parc.nii.gz ] && mri_label2vol --annot ${annot_data} --temp ./fsaverage/mri/brain.mgz --subject fsaverage --hemi ${hemi} --o ./${hemi}.parc.nii.gz --identity --proj frac 0 1 0.1
done

if [ ! -f ./lh.parc.nii.gz ] || [ ! -f ./rh.parc.nii.gz ] ; then
	echo "something went wrong. check logs and derivatives"
	exit 1
fi

echo "complete"