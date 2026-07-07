# MDFF-NM – Pipeline de Ajuste Flexível com Modos Normais usando R
## 📌 Descrição
O MDFF_NM é um conjunto de scripts que implementa um algoritmo híbrido de ajuste estrutural, combinando Dinâmica Molecular (MD) com Análise de Modos Normais (NMA). Esse pipeline foi desenvolvido para refinar estruturas de proteínas em mapas de densidade de cryo-EM, explorando múltiplas trajetórias de ajuste e aumentando a diversidade conformacional obtida.

O workflow integra:
* Preparação de arquivos de entrada para NAMD e VMD
* Execução de simulações com excitações baseadas em modos normais
* Geração de trajetórias independentes
* Análise de RMSD, correlação cruzada e qualidade estrutural

## 🎯 Quando usar
* Refinar estruturas em mapas de densidade de cryo-EM
* Explorar diferentes rotas de ajuste estrutural
* Combinar simulações de MD com excitações de modos normais

## 📂 O que este pipeline gera
* Trajetórias independentes de ajuste
* Arquivos de coordenadas por ciclo (cycle_X.coor)
* Arquivos concatenados em formato DCD
* Resultados de RMSD em .txt
* Mapas de correlação cruzada com o alvo experimental
  
---
⚙️ Requisitos
[Requirements](https://github.com/Labbiofisbiocomp/MDFF-NM-Molecular-Dynamics-Flexible-Fitting-Normal-Modes/blob/main/requirements.md)

---
## 🔄 Visão geral do pipeline
Equilibração inicial
        ↓
Configuração de parâmetros no inputs_mdff_nm.R
        ↓
Execução de simulações MDFF_NM
        ↓
Geração de trajetórias independentes
        ↓
Concatenação e análise (RMSD, correlação cruzada)

---
## ▶️ Como executar (passo a passo)
Clone o repositório e configure o ambiente:

```bash
git clone https://github.com/Labbiofisbiocomp/mdff_nm.git
cd mdff_nm/files
```
Edite o arquivo de parâmetros:
``` R
inputs_mdff_nm.R
```
Execute o pipeline:
```bash
sh run-serial-mdff-nm-final.sh
```
O script solicitará o número de réplicas e criará pastas numeradas com os resultados.

---
## 📥 Inputs
* adk-equi.pdb → coordenadas iniciais
* adk-equi.vel → velocidades iniciais
* 4ake_target.pdb → estrutura alvo para geração do mapa
* initial.psf → topologia inicial

## 📤 Outputs
* cycle_X.coor → coordenadas por ciclo
* traj.dcd → trajetórias concatenadas por réplica
* rmsd_X.txt → resultados de RMSD
* Mapas de correlação cruzada

---

## 🧪 Estrutura dos arquivos
* mdff_nm.R → Script central do protocolo (não editar).
* inputs_mdff_nm.R → Arquivo de entrada editável pelo usuário (parâmetros da simulação).
* functions_mdff_nm.R → Biblioteca de funções auxiliares (não editar).
* config.namd → Configuração do NAMD (pode ser adaptada por usuários experientes).
* par_all36_prot.prm → Parâmetros do campo de força CHARMM36.

## Scripts auxiliares (VMD + Shell)
* template_prepare.tcl / prepare.sh → Preparação inicial (topologia, coordenadas, grids).
* get_ccc.tcl / ccc.sh → Cálculo de correlação cruzada (CCC).
* template_restraints.tcl / restraints.sh → Geração de restrições espaciais.
  
## ⚙️ Configuração pelo usuário
O arquivo inputs_mdff_nm.R concentra os parâmetros principais:
* Estruturas iniciais (coor.pdb, vel.pdb)
* Mapa experimental (expmap, target.pdb)
* Resolução do mapa (res)
* Ciclos de MD e modos normais (steps.md, percent.modes, trial.vector.modes, ek, maxcycles)
* Parâmetros NAMD (g_scale, k_prot, hbbondk, hbanglek, langevin)
* Comando de execução (namd.input)

## 🚀 Execução da simulação
Após editar inputs_mdff_nm.R, a simulação é iniciada com:
```bash
sh run-serial-mdff-nm-final.sh
```
Esse script:
* Pergunta o número de réplicas desejadas
* Cria pastas numeradas para cada réplica
* Executa os ciclos de excitação MDFF_NM
* Gera arquivos de saída cycle_X.coor (PDB), onde X é o número do ciclo

## 📊 Pós-processamento
* As coordenadas de cada réplica podem ser concatenadas em um único DCD usando ferramentas como catdcd
* Scripts auxiliares (ccc.sh, restraints.sh) permitem calcular métricas de ajuste e aplicar restrições adicionais

---
## ⚠️ Observações importantes
* O arquivo mdff_nm.R não deve ser editado.
* Apenas inputs_mdff_nm.R deve ser configurado pelo usuário.
* O arquivo config.namd pode ser ajustado por usuários experientes.
* Verifique os outputs antes de prosseguir para análises.

## 📌 Autoria
Este pipeline pertence a: DOI [10.1021/acs.jcim.3c02007](https://doi.org/10.1021/acs.jcim.3c02007?urlappend=%3Fref%3DPDF&jav=VoR&rel=cite-as)
