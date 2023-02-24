/*
 * psi.c
 *
 *
 * Implementation of Broecker's and Kuhl's PSI model Broecker (2000),
 * p.63
 * 
 *
 * Ivo Siekmann, 19th September 2020
 *
 * 
 * Compile with:
 *
 * gcc -Wall -pedantic -o filename filename.c
 *
 */

#include <stdio.h>
#include <math.h>

#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_errno.h>

#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#include "psi.h"

#define NPERT 1000
  /* Perturbations */
static  double a=0.275;
static  double deltaT=10;

#ifdef TEST
static  double deltaPertT=50;
static  double probPertPlus=0.5;
static  double pertT=0;
#endif

static  double aPlusPert[NPERT]={20,140};
static  size_t naPlus=2;
static  double aMinusPert[NPERT]={60};
static  size_t naMinus=1;


/* General form of a perturbation */
double pert(double t, double t0, double Delta, double scale) {
  if( (t<=t0) || (t>=t0+Delta) ) return 0;

  return scale*sin( (t-t0)/Delta*PI);
}

int heaviside(double x) {
  if(x<=0)
    return 0;

  return 1;
}

/* Function that returns positive affect */
double bPlus(double btP, double sPP, double sPM, double Delta, double F, double P) {
  double DeltaBtP=Delta*heaviside(Delta);
  double DeltaBtM=-Delta*heaviside(-Delta);
    
  double  FPd1=(F-P-DeltaBtP)*heaviside(F-P-DeltaBtP);
  double  FPd2=(F-P-DeltaBtM)*heaviside(P-F-DeltaBtM);
    
  double  arg=-sPP*FPd1 - sPM*FPd2;
    
  return (btP + 2.0/(1.0 + exp(arg)));
}

/* Function that returns negative affect */
double bMinus(double btM, double sMP, double sMM, double Delta, double F, double P) {
  double DeltaBtP=Delta*heaviside(Delta);
  double DeltaBtM=-Delta*heaviside(-Delta);
    
  double FPd1=(P-F+DeltaBtM)*heaviside(P-F-DeltaBtM);
  double FPd2=(P-F+DeltaBtP)*heaviside(F-P-DeltaBtP);
    
  double arg=-sMP*FPd1 - sMM*FPd2;
    
  return (btM + 2.0/(1.0 + exp(arg)));
}

double bPlusPert=0, bMinusPert=0;

int psi(double t, const double y[], double dydt[], void * pars) {
  double f = y[0];
  double e = y[1];
  double p = y[2];
  double v = y[3];
  double s = 1;

  double btP=0, btM=0;

  double bplus=0, bminus=0;
  
  psi_pars* par=(psi_pars*)pars;

#ifndef DET
  int k;
#endif
  
  /*generate affect (either for pre-defined scenario (DET) or
    according to Poisson process). */
#ifdef DET
  btP = pert(t, 20, deltaT, a) + pert(t, 140, deltaT, a);
#else
  for(k=0; k<naPlus; k++) {
    btP += pert(t, aPlusPert[k], deltaT, a);
  }
 #endif

#ifdef DET
  btM =  pert(t, 60, deltaT, a);
#else
  for(k=0; k<naMinus; k++) {
    btM +=  pert(t, aMinusPert[k], deltaT, a);
  }
#endif
  
  bplus=par->btP + btP+bPlus(0,par->sPP, par->sPM, par->Delta, f, p);
  bminus=par->btM + btM+bMinus(0, par->sMP, par->sMM, par->Delta, f, p);

  dydt[0] = (1.0-e/bminus)*f;
  dydt[1] = -(4.0-bminus)*(4.0-bminus)*e + bminus*f*f;
  dydt[2] = (1-v/(bplus*s))*p;
  dydt[3] = -(4.0-bplus)*(4-bplus)*v+bplus*p*p;

  /* For calculating the area under the curve */
  /* Subtract steady state */
  dydt[4] = f-3;
  dydt[5] = e-1;

  dydt[6] = p-3;
  dydt[7] = v-1;
    
  return GSL_SUCCESS;
}

#ifdef TEST

#define OUT stdout
#define ERR stderr

psi_pars psi_p={
  /* 0.5, 0.5, */
  /*   1.5, 0.5, */
  0.75, 0.75,
  1.25, 0.45,
  0.0, 0.0,
  /* 0.0, 0.1, */
  0.0
};

gsl_odeiv2_system psi_Model = {psi, NULL,
			       PSI_D, &psi_p};

int main(int argc, char **argv) {
  const char *titles="t\tEM\tOR\tIM\tIB\tEM_A\tOR_A\tIM_A\tIB_A\tApPert\tAmPert\tAp\tAm";
  double tend=200;
  double y[]={3, 1, 3, 1, 0, 0, 0, 0};
  double t=0;
  double ht=0.1;

  int i;

  gsl_odeiv2_driver *d = gsl_odeiv2_driver_alloc_y_new (&psi_Model,
							gsl_odeiv2_step_rkf45,
							 1e-12, 1e-12, 0.0);

  gsl_rng *r;

  /* Get seed for random number generator from environment variable */
  gsl_rng_env_setup();

  r=gsl_rng_alloc(gsl_rng_taus);
  if(argc>=5) {
    psi_p.sPP=atof(argv[1]);
    psi_p.sPM=atof(argv[2]);
    psi_p.sMP=atof(argv[3]);
    psi_p.sMM=atof(argv[4]);	
  }

  if(argc>=7) {
    psi_p.btP=atof(argv[5]);
    psi_p.btM=atof(argv[6]);
  }

  #ifndef DET
  if(argc>=8) {
    tend=atof(argv[7]);
  }

  if(argc>=9) {
    probPertPlus=atof(argv[8]);
  }
  #endif

  y[0]=3.0-psi_p.btM;
  y[1]=1.0+psi_p.btM;
  y[2]=3.0-psi_p.btP;
  y[3]=1.0+psi_p.btP;
  
  fprintf(ERR, "Parameters:\n");
  fprintf(ERR, "sPP=%g, sPM=%g, sMP=%g, sMM=%g\n",
  	  psi_p.sPP, psi_p.sPM, psi_p.sMP, psi_p.sMM);
  fprintf(ERR, "btP=%g, btM=%g\n",
  	  psi_p.btP, psi_p.btM);

#ifndef DET
  fprintf(ERR, "probPertPus=%g\n", probPertPlus);

  fprintf(ERR, "tend=%g\n", tend);
#endif

  fprintf(ERR, "\nInitial conditions:\n");
  fprintf(ERR, "EM0=%g, OR0=%g,IM0=%g, IB0=%g\n",
  	  y[0],y[1],y[2],y[3]); 

  /* Output header */
  fprintf(OUT, "%s\n", titles);
  fprintf(OUT, "%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\t%g\n", 0.0, y[0], y[1], y[2], y[3], y[4], y[5], y[6], y[7]);

  /* Initialise perturbations */
  pertT=gsl_ran_exponential(r, deltaPertT);
  while(pertT<=tend) {
    if(gsl_rng_uniform(r) < probPertPlus) {
      aPlusPert[naPlus++]=pertT;
    }
    else {
      aMinusPert[naMinus++]=pertT;
    }
    pertT+=gsl_ran_exponential(r, deltaPertT);
  }
  /* OPTIONAL: Output of perturbations */
  /* fprintf(ERR, "Aplus perturbations:\n"); */
  /* for(i=0; i<naPlus-1; i++) { */
  /*   fprintf(ERR, "%g\t", aPlusPert[i]); */
  /* } */
  /* fprintf(ERR, "%g\n", aPlusPert[i]); */

  /* fprintf(ERR, "Aminus perturbations:\n"); */
  /* for(i=0; i<naMinus-1; i++) { */
  /*   fprintf(ERR, "%g\t", aMinusPert[i]); */
  /* } */
  /* fprintf(ERR, "%g\n", aMinusPert[i]); */

  for (i = 1; i*ht <= tend; i++)
    {
      double ti = i*ht;
      int status = gsl_odeiv2_driver_apply (d, &t, ti, y);
      int k;

      double f=0,p=0;
      double btP=0, btM=0;
      double bplus=0, bminus=0;
      
      if (status != GSL_SUCCESS)
     	{
     	  printf ("error, return value=%d\n", status);
     	  break;
     	}

      fprintf(OUT, "%g\t", t);
      for(k=0; k<PSI_D-1; k++) fprintf(OUT, "%g\t", y[k]);
      fprintf(OUT, "%g", y[k]);

      /* Calculate affect */
      f = y[0];
      p = y[2];

#ifdef DET
      btP = pert(t, 20, deltaT, a) + pert(t, 140, deltaT, a);
        
      btM =  pert(t, 60, deltaT, a);
#else
      btP=0;
      for(k=0; k<naPlus; k++) {
	btP += pert(t, aPlusPert[k], deltaT, a);
      }

      btM=0;
      for(k=0; k<naMinus; k++) {
	btM +=  pert(t, aMinusPert[k], deltaT, a);
      }
#endif
      
      bplus=psi_p.btP + btP+bPlus(0,psi_p.sPP, psi_p.sPM, psi_p.Delta, f, p);
      bminus=psi_p.btM + btM+bMinus(0, psi_p.sMP, psi_p.sMM, psi_p.Delta, f, p);

      fprintf(OUT, "\t%g\t%g\t%g\t%g", btP, btM, bplus, bminus);
      fprintf(OUT, "\n");
    }

  gsl_odeiv2_driver_free (d);

  gsl_rng_free(r);

  /* Output AUC divided by time interval. */
  /* fprintf(ERR, "EM_A\tOR_A\tIM_A\tIB_A\n"); */
  for(i=PSI_D-4; i<PSI_D-1; i++) {
    fprintf(ERR, "%g\t", y[i]/tend);
  }
  fprintf(ERR, "%g\n", y[i]/tend);
  
  return 0;  
}
#endif
