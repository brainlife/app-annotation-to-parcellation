<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Converts left and right surface annotations on an fsaverage template into a volumetric parcellation in fsaverage space with FreeSurfer mri_label2vol and Connectome Workbench.**

Projects each hemisphere's annotation into the volume of the chosen fsaverage template (mri_label2vol, filling the cortical ribbon), reads the label names with Connectome Workbench, and combines both hemispheres into one parcellation with label.json. Use it for annotations already in fsaverage (standard) space, not subject space.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.747](https://doi.org/10.25663/brainlife.app.747)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `annotation` | `neuro/surface/data` (annotation, standard) | yes | Left and right hemisphere surface annotations in fsaverage space. Must be defined on the same fsaverage mesh selected in the fsaverage parameter. |

| Output | Datatype | Description |
|---|---|---|
| `parcellation` | `neuro/parcellation/volume` | Volumetric parcellation (parc.nii.gz) in fsaverage volume space with label.json. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `fsaverage` | enum | `fsaverage` | fsaverage template (mesh resolution) on which the annotations are defined; its brain.mgz is the output volume grid. Options: `fsaverage`, `fsaverage3`, `fsaverage4`, `fsaverage5`, `fsaverage6`, `fsaverage_sym`. |

Runtime: container `brainlife/freesurfer:7.3.2`; 4 CPUs; 0.5 h walltime; needs `FREESURFER_LICENSE`.

<!-- brainlife-app:end -->

# app-annotation-to-parcellation