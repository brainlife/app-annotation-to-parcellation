<h1 align="center">Annotation to volumetric parcellation</h1>

<p align="center">
  A volumetric parcellation in fsaverage space from left and right surface annotations defined on an fsaverage template.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.747"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.747-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Converts left and right surface annotations on an fsaverage template into a volumetric parcellation in fsaverage space with FreeSurfer mri_label2vol and Connectome Workbench.**

Projects each hemisphere's annotation into the volume of the chosen fsaverage template (mri_label2vol, filling the cortical ribbon), reads the label names with Connectome Workbench, and combines both hemispheres into one parcellation with label.json. Use it for annotations already in fsaverage (standard) space, not subject space.

| | |
|---|---|
| 📥 **Inputs** | `neuro/surface/data` |
| 📤 **Outputs** | `neuro/parcellation/volume` |
| 🐳 **Container** | `brainlife/freesurfer:7.3.2` |
| ⚙️ **Resources** | 4 CPUs · 0.5 h walltime |
| 🔑 **Requires** | `FREESURFER_LICENSE` |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.747](https://doi.org/10.25663/brainlife.app.747) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `annotation` | `neuro/surface/data` (annotation, standard) | yes | Left and right hemisphere surface annotations in fsaverage space. Must be defined on the same fsaverage mesh selected in the fsaverage parameter. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `parcellation` | `neuro/parcellation/volume` | Volumetric parcellation (parc.nii.gz) in fsaverage volume space with label.json. |

<details>
<summary><b>⚙️ Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `fsaverage` | enum | `fsaverage` | fsaverage template (mesh resolution) on which the annotations are defined; its brain.mgz is the output volume grid. Options: `fsaverage`, `fsaverage3`, `fsaverage4`, `fsaverage5`, `fsaverage6`, `fsaverage_sym`. |

</details>

<!-- brainlife-app:end -->

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.747](https://doi.org/10.25663/brainlife.app.747), choose a `neuro/surface/data` dataset tagged `annotation` and `standard` (left and right hemisphere annotations in fsaverage space), pick the fsaverage template the annotations are defined on, and press **Execute**. The App writes a `neuro/parcellation/volume` dataset (tagged `standard`) to your project.

The App is meant for annotations that are already in fsaverage (standard) space, not in subject space. The annotations must be defined on the same fsaverage mesh you select in the `fsaverage` parameter (`fsaverage`, `fsaverage3`, `fsaverage4`, `fsaverage5`, `fsaverage6` or `fsaverage_sym`).

### 🔬 How it works

1. Each hemisphere's annotation is projected into the volume of the selected fsaverage template with FreeSurfer `mri_label2vol`, filling the cortical ribbon (`--proj frac 0 1 0.1`) on the grid of the template's `mri/brain.mgz`.
2. The label names and values of each annotation are exported with Connectome Workbench `wb_command -label-export-table`.
3. The two hemispheres are combined into a single parcellation with NiBabel; right-hemisphere label values are offset by the number of left-hemisphere labels, and a `label.json` describing every label is written next to the volume.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). The fsaverage templates are shipped in this repository under `templates/`.

1. Clone this repository.
2. Create `config.json` with the paths to the left and right annotations (GIFTI label files) and the template:

   ```json
   {
       "left": "/input/annotation/lh.annot.label.gii",
       "right": "/input/annotation/rh.annot.label.gii",
       "fsaverage": "fsaverage"
   }
   ```

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

The App uses the `brainlife/freesurfer:7.3.2`, `brainlife/connectome_workbench:1.5.0` and `brainlife/dipy:1.4.1` containers.

## 📦 Outputs

```text
parcellation/
├── parc.nii.gz    volumetric parcellation in fsaverage volume space
└── label.json     name, description and voxel value of every label
raw/               per-hemisphere volumes (lh/rh.parc.nii.gz), label tables and GIFTI copies
```

## 🩺 Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: no FreeSurfer license is available. Set the `FREESURFER_LICENSE` environment variable when running locally; brainlife.io provides it automatically.
- **`something went wrong. check logs and derivatives`**: the per-hemisphere volumes or the combined parcellation were not produced. Check that the annotations match the selected fsaverage template.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Convert surface-based annotation in standard space to parcellation (volume). brainlife.io App. [doi:10.25663/brainlife.app.747](https://doi.org/10.25663/brainlife.app.747)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Marcus et al. Informatics and Data Mining Tools and Strategies for the Human Connectome Project. *Frontiers in Neuroinformatics* 5 (2011). [doi:10.3389/fninf.2011.00004](https://doi.org/10.3389/fninf.2011.00004)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron
- Franco Pestilli (project director)

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). FreeSurfer and Connectome Workbench are distributed under their own licenses.
