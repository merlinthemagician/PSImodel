Implementation of the PSI model  by Bröcker (2000)
========

## Extension by stochastic perturbation (Hoy et al., 2023)

The PSI model describes the dynamics of the activity levels of the four cognitive systems object recognition (OR), intuitive behaviour (IB), intention memory (IM) and extension memory (EM) over time under the influence of positive and negative affect. According to the *personality systems interactions (PSI) theory* (Kuhl, 2000), personality is influenced to a large extent by the cognitive system that is primarily active. 

The parameters of the model are

 - the four sensitivities to down- or upregulating negative or positive affect, respectively - s^+^~Down~,  s^+^~Up~, s^-^~Down~ and s^-^~Up~. 
 
 - tonic positive and negative affect, b^+^~t~ and b^-^~t~ determine if positive or negative are permanently increased or decreased. 
 
 - The probability p^+^ that an affect perturbation generates positive rather than negative affect. 

### Numerical solution of the PSI model

The PSI model by Bröcker (2000), extended as described in Hoy et al. (2023), is implemented in C. Positive and negative affect perturbations are generated using a Poisson process model. The code depends on the GNU Scientific library [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). It can be compiled by adjusting the `makefile`.

Both executables, `psi` and `psiDet` are implemented in the same file, `psi.c`.

 - psi: Solves the PSI model where affect perturbations are generated via a Poisson process model. Here, `sPUp sPDown sMUp sMDown` are the affect sensitivities, ` bPt bMt` are tonic positive and tonic negative affect, respectively, `tend` is the simulation time and `pPlus` is the probability of positive affect perturbations.   
   
   Usage: `./psi sPUp sPDown sMUp sMDown bPt bMt tend pPlus`
 
 - psiDet: Solves the PSI model for a fixed sequence of affect perturbations. Here, `sPUp sPDown sMUp sMDown` are the affect sensitivities and ` bPt bMt` are tonic positive and tonic negative affect, respectively.   
   
    Usage: `./psi sPup sPDown sMUp sMDown bPt bMt`  
 
 
### Plotting
 
 Solutions of the model can be plotted using `gnuplot` by running the shell scripts `plot_psi.plt` and `plot_psiDet.plt`. 
 
### Statistical analysis of the activities of the cognitive systems for stochastic affect perturbations
 
 

