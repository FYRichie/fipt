#! /bin/bash

# data folder
DATASET_ROOT='data/hypersim/'
DATASET='real'
# scene name
SCENE='ai_01_001'
# whether has part segmentation
HAS_PART=0

# shading initialization
python bake_shading.py --scene $DATASET_ROOT$SCENE\
                       --output 'outputs/'$SCENE --dataset $DATASET

# BRDF-emission estimation
python train.py --experiment_name $SCENE --device 0 --max_epochs 2\
        --dataset $DATASET $DATASET_ROOT$SCENE 'outputs/'$SCENE\
        --voxel_path 'outputs/'$SCENE'/vslf.npz'\
        --has_part $HAS_PART

# extract emitters
python extract_emitter.py --scene $DATASET_ROOT$SCENE\
        --output 'outputs/'$SCENE --dataset $DATASET\
        --ckpt 'checkpoints/'$SCENE'/last.ckpt'

# refine shadings
python refine_shading.py --scene $DATASET_ROOT$SCENE\
        --output 'outputs/'$SCENE --dataset $DATASET\
        --ckpt 'checkpoints/'$SCENE'/last.ckpt' --ft 1 