#!/bin/bash

icvf=`jq -r '.icvf' config.json`
od=`jq -r '.od' config.json`
isovf=`jq -r '.isovf' config.json`
ad=`jq -r '.ad' config.json`
fa=`jq -r '.fa' config.json`
md=`jq -r '.md' config.json`
rd=`jq -r '.rd' config.json`
mask=`jq -r '.mask' config.json`
roi=`jq -r '.roi' config.json`
parc=`jq -r '.parc' config.json`

if [ ! -f ${icvf} ]; then
	metric="ad fa md rd"
	echo ${metric}
elif [ -f ${icvf} ] && [ -f ${fa} ]; then
	metric="ad fa icvf isovf md od rd"
	echo ${metric}
else
	metric="icvf isovf od"
	echo ${metric}
fi

# if mask
#if [ -f ${mask} ]; then
	for MET in ${metric}
	do
		if [ ! -f ${MET}_masked.nii.gz ]; then
			fslmaths ${!MET} -mul ${mask} ${MET}_masked.nii.gz
		fi
		fslstats ${MET}_masked.nii.gz -M > ${MET}.txt
	done
#else
#fi

printf '%s\n' ${metric} | paste -sd ',' >> output.csv
printf '%s\n' `cat *.txt` | paste -sd ',' >> output.csv

# binarize roi
#for ROI in dwi_*.nii.gz
#do
#	fslmaths ${ROI} -bin bin_${ROI}
#	for MET in ${metric}
#	do
#		fslmaths ${!MET} -mul bin_${ROI} ${MET}_${ROI}
#	done
#done
