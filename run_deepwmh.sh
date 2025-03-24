#!/bin/bash

# Define variables for subject ID, data directory, output directory, and input image
export subj_id="0a8d02f2b"
export data_dir="/data_dzne_archiv2/Studien/Deep_Learning_Visualization/temporary_stuff/Jaya_Chandra_Terli/docker-deepwmh/test_FLAIR/data"
export working_dir="/data_dzne_archiv2/Studien/Deep_Learning_Visualization/temporary_stuff/Jaya_Chandra_Terli/docker-deepwmh/test_FLAIR"
export flair_img="flair_Repseudonym_0a8d02f2bM0_T1_01_2.nii"

cd $working_dir
# Ensure the logs and output directory exists
mkdir -p $working_dir/logs
mkdir -p $working_dir/output

# Run the Docker container with the DeepWMH_predict tool
docker run --rm --gpus all \
    -v $data_dir:/data \
    -v $working_dir/output:/output \
    deepwmh:v.1.0.1 \
    -i /data/$flair_img \
    -n $subj_id \
    -m /model \
    -o /output/$subj_id \
    -g 0 > $working_dir/logs/${subj_id}.log 2>&1 &