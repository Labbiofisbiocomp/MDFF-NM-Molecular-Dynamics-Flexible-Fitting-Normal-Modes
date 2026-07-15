# MDFF-NM – Flexible Fitting Pipeline with Normal Modes Using R

## 📌 Description
**MDFF-NM (Molecular Dynamics Flexible Fitting – Normal Modes)** is a computational pipeline developed to perform flexible fitting of protein structures into cryo-electron microscopy (cryo-EM) density maps by combining **Molecular Dynamics (MD)** and **Normal Mode Analysis (NMA)**. The methodology uses normal modes to guide collective protein motions during the fitting process, enabling the exploration of multiple conformational pathways and improving the efficiency of structural refinement.

**Authors:**
> DAHMANI, Zakaria L. et al. *MDFF_NM: Improved Molecular Dynamics Flexible Fitting into Cryo-EM Density Maps with a Multireplica Normal Mode-Based Search.* Journal of Chemical Information and Modeling, v. 64, n. 13, p. 5151–5160, 2024.  
> DOI: **10.1021/acs.jcim.3c02007**

---
⚙️ Requirements

The requirements are available at:

[Requirements](https://github.com/Labbiofisbiocomp/MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes/blob/main/requirements.md)

---

# 📖 About the Project

The MDFF-NM pipeline was developed to:

- refine protein structures into cryo-EM density maps;
- explore multiple conformational pathways;
- combine Molecular Dynamics and Normal Mode Analysis;
- generate trajectories for downstream structural analyses.

---

# 📂 Repository Structure

```text
.
├── files/                        # User-editable files
├── inputs/                       # Input files
├── tutorials/
├── requirements.md
├── run-serial-mdff-nm-final.sh   # Main script
├── rmsd_multireplica_MDFF_NM.sh  # RMSD generation script
├── README-en.md
└── README.md
```

## 🔄 Pipeline Overview

```text
Initial equilibration
        ↓
Parameter configuration in inputs_mdff_nm.R
        ↓
MDFF-NM simulations
        ↓
Generation of independent trajectories
        ↓
Trajectory concatenation and RMSD analysis
        ↓
Structure projection
```

---

## ▶️ How to Run

Clone the repository:

```bash
git clone https://github.com/lbcb-ufabc/MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes.git

cd MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes
```

Edit the simulation parameters in:

```R
inputs_mdff_nm.R
```

Run the pipeline:

```bash
sh run-serial-mdff-nm-final.sh
```

Generate the `.dcd` files and RMSD results:

```bash
sh rmsd_multireplica_MDFF_NM.sh
```

---

# 📚 Tutorials

The repository includes two main tutorials.

## 1. MDFF-NM Tutorial

Presents the complete workflow of the protocol.

## 2. Trajectory Analysis Tutorial

After running MDFF-NM, this tutorial demonstrates how to:

- project the structures into Principal Component Analysis (PCA) space;
- compare the generated trajectories with experimental structures;
- visualize conformational sampling using the **ProDy** package.

---

## 📥 Inputs

* `adk-equi.pdb` → Initial structure
* `adk-equi.vel` → Initial velocities
* `4ake_target.pdb` → Target structure for density map generation

## 📤 Outputs

At the end of the execution, the pipeline generates:

* independent trajectories
* `cycle_X.coor` files
* `.dcd` files
* `RMSD.txt` results
* Cross-Correlation Coefficient (CCC) maps
* fitted structures

---

## 🧪 File Structure

* `mdff_nm.R` → Core protocol script.
* `inputs_mdff_nm.R` → User-editable input file (simulation parameters).
* `functions_mdff_nm.R` → Auxiliary function library.
* `config.namd` → NAMD configuration file.
* `par_all36_prot.prm` → CHARMM36 force field parameters.

## Auxiliary Scripts (VMD + Shell)

* `template_prepare.tcl` / `prepare.sh` → Initial preparation (topology, coordinates, and grids).
* `get_ccc.tcl` / `ccc.sh` → Cross-Correlation Coefficient (CCC) calculation.
* `template_restraints.tcl` / `restraints.sh` → Generation of spatial restraints.

---

## ⚠️ Important Notes

* Only `inputs_mdff_nm.R` should be configured by the user.
* Verify the generated outputs before proceeding with downstream analyses.
