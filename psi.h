#ifndef PSI
#define PSI
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

#define PI ( atan(1)*4.0 )

/* #define PSI_D 4 */
/* #define PSI_D 5 */
#define PSI_D 8

typedef struct {
  double sPP, sPM;
  double sMP, sMM;
  double btP, btM;
  double Delta;
} psi_pars;

/* Implementation of the ODE system by Broecker (2000) */
int psi(double t, const double y[], double dydt[], void * pars);
#endif
