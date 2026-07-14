# MDFF-NM – Pipeline de Ajuste Flexível com Modos Normais usando R
## 📌 Descrição
O **MDFF-NM (Molecular Dynamics Flexible Fitting – Normal Modes)** é um pipeline computacional desenvolvido para realizar o ajuste flexível de estruturas proteicas em mapas de densidade de microscopia crioeletrônica (cryo-EM), combinando **Dinâmica Molecular (Molecular Dynamics - MD)** e **Análise de Modos Normais (Normal Mode Analysis - NMA)**. A metodologia utiliza modos normais para direcionar movimentos coletivos da proteína durante o processo de ajuste, permitindo explorar diferentes trajetórias conformacionais e aumentar a eficiência do refinamento estrutural.

**Autoria:**
> DAHMANI, Zakaria L. et al. MDFF_NM: Improved molecular Dynamics Flexible Fitting into cryo-EM density maps with a multireplica normal mode-based search. Journal of Chemical Information and Modeling, v. 64, n. 13, p. 5151–5160, 2024. 
> DOI: **10.1021/acs.jcim.3c02007**

---
⚙️ Requisitos
Os requisitos estão disponíveis em:
[Requirements](https://github.com/Labbiofisbiocomp/MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes/blob/main/requirements.md)

---

# 📖 Sobre o projeto

O pipeline MDFF-NM foi desenvolvido para:
- refinar estruturas em mapas de densidade de Cryo-EM;
- explorar múltiplas trajetórias conformacionais;
- combinar Dinâmica Molecular e Modos Normais;
- gerar trajetórias para análises estruturais posteriores.

---

# 📂 Estrutura do repositório

```
.
├── files/                        # Arquivo editável pelo usuário
├── inputs/                       # Arquivos de entrada  
├── tutorials/
├── requirements.md
├── run-serial-mdff-nm-final.sh   # Script principal
├── rmsd_multireplica_MDFF_NM.sh  # Script para gerar o rmsd
└── README.md
```

## 🔄 Visão geral do pipeline
Equilibração inicial
        ↓
Configuração de parâmetros no inputs_mdff_nm.R
        ↓
Execução de simulações MDFF_NM
        ↓
Geração de trajetórias independentes
        ↓
Concatenação e análise (RMSD)
        ↓
Projeção das estruturas

---
## ▶️ Como executar
Clone o repositório:

```bash
git clone https://github.com/lbcb-ufabc/MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes.git

cd MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes
```

Edite os parâmetros da simulação em:

```R
inputs_mdff_nm.R
```

Execute o pipeline:

```bash
sh run-serial-mdff-nm-final.sh
```

Gere os arquivos .dcd e RMSD:

```bash
sh rmsd_multireplica_MDFF_NM.sh
```

---

# 📚 Tutoriais

O repositório possui dois tutoriais principais.

## 1. Tutorial MDFF-NM

Apresenta o funcionamento completo do protocolo

## 2. Tutorial de Análise de Trajetórias

Após a execução do MDFF-NM, este tutorial mostra como:

- projetar as estruturas no espaço das Componentes Principais (PCA);
- comparar as trajetórias geradas com estruturas experimentais;
- visualizar a amostragem conformacional utilizando o pacote **ProDy**.

---

## 📥 Inputs
* adk-equi.pdb → Estrutura inicial
* adk-equi.vel → Velocidades iniciais
* 4ake_target.pdb → Estrutura alvo para geração do mapa

## 📤 Outputs
Ao final da execução são gerados:

* trajetórias independentes
* arquivos `cycle_X.coor`
* arquivos `.dcd`
* resultados de RMSD.txt
* mapas de correlação cruzada (CCC)
* estruturas ajustadas

---

## 🧪 Estrutura dos arquivos
* mdff_nm.R → Script central do protocolo.
* inputs_mdff_nm.R → Arquivo de entrada editável pelo usuário (parâmetros da simulação).
* functions_mdff_nm.R → Biblioteca de funções auxiliares.
* config.namd → Configuração do NAMD.
* par_all36_prot.prm → Parâmetros do campo de força CHARMM36.

## Scripts auxiliares (VMD + Shell)
* template_prepare.tcl / prepare.sh → Preparação inicial (topologia, coordenadas, grids).
* get_ccc.tcl / ccc.sh → Cálculo de correlação cruzada (CCC).
* template_restraints.tcl / restraints.sh → Geração de restrições espaciais.

---

## ⚠️ Observações importantes
* Apenas inputs_mdff_nm.R deve ser configurado pelo usuário.
* Verifique os outputs antes de prosseguir para análises.
