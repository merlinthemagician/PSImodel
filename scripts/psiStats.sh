#!/bin/zsh

######################################################################
## Generate simulation results
######################################################################
DIR=~/c/PSI

# Agreeable
SPP=1.25
SPM=0.45
SMP=0.75
SMM=0.75

BP=0
BN=0

P_APLUS=1.0

TEND=1000

SPP_STR="${"${SPP//0./0}"//./0}"
SPM_STR="${"${SPM//0./0}"//./0}"
SMP_STR="${"${SMP//0./0}"//./0}"
SMM_STR="${"${SMM//0./0}"//./0}"

P_APLUS_STR="${"${P_APLUS//0./0}"//./0}"

OUT=AUC_PSI_spp${SPP_STR}_spm${SPM_STR}_smp${SMP_STR}_smm${SMM_STR}_bp${BP}_bn${BN}_prAplus${P_APLUS_STR}_tend${TEND}.dat

print "EM\tOR\tIM\tIB" >${OUT}

N=100

for i in `seq 1 ${N}`; do
    
    # GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND 2>&1 >/dev/null | tail -n 1
    # More complicated in zsh than in bash, see:
    #
    # https://unix.stackexchange.com/questions/265061/how-can-i-pipe-only-stderr-in-zsh
    GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND $P_APLUS 2>&1 >&- > /dev/null | tail -n 1 >> ${OUT}
done


# Independent
SPP=0.45
SPM=1.25
SMP=0.75
SMM=0.75

SPP_STR="${"${SPP//0./0}"//./0}"
SPM_STR="${"${SPM//0./0}"//./0}"
SMP_STR="${"${SMP//0./0}"//./0}"
SMM_STR="${"${SMM//0./0}"//./0}"

OUT=AUC_PSI_spp${SPP_STR}_spm${SPM_STR}_smp${SMP_STR}_smm${SMM_STR}_bp${BP}_bn${BN}_prAplus${P_APLUS_STR}_tend${TEND}.dat

print "EM\tOR\tIM\tIB" >${OUT}

for i in `seq 1 ${N}`; do
    
    # GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND 2>&1 >/dev/null | tail -n 1
    # More complicated in zsh than in bash, see:
    #
    # https://unix.stackexchange.com/questions/265061/how-can-i-pipe-only-stderr-in-zsh
    GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND $P_APLUS 2>&1 >&- > /dev/null | tail -n 1 >> ${OUT}
done

# Self-determined
SPP=0.75
SPM=0.75
SMP=1.25
SMM=0.45

SPP_STR="${"${SPP//0./0}"//./0}"
SPM_STR="${"${SPM//0./0}"//./0}"
SMP_STR="${"${SMP//0./0}"//./0}"
SMM_STR="${"${SMM//0./0}"//./0}"

OUT=AUC_PSI_spp${SPP_STR}_spm${SPM_STR}_smp${SMP_STR}_smm${SMM_STR}_bp${BP}_bn${BN}_prAplus${P_APLUS_STR}_tend${TEND}.dat

print "EM\tOR\tIM\tIB" >${OUT}

for i in `seq 1 ${N}`; do
    
    # GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND 2>&1 >/dev/null | tail -n 1
    # More complicated in zsh than in bash, see:
    #
    # https://unix.stackexchange.com/questions/265061/how-can-i-pipe-only-stderr-in-zsh
    GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND $P_APLUS 2>&1 >&- > /dev/null | tail -n 1 >> ${OUT}
done

# Conscientious
SPP=0.75
SPM=0.75
SMP=0.45
SMM=1.25

SPP_STR="${"${SPP//0./0}"//./0}"
SPM_STR="${"${SPM//0./0}"//./0}"
SMP_STR="${"${SMP//0./0}"//./0}"
SMM_STR="${"${SMM//0./0}"//./0}"

OUT=AUC_PSI_spp${SPP_STR}_spm${SPM_STR}_smp${SMP_STR}_smm${SMM_STR}_bp${BP}_bn${BN}_prAplus${P_APLUS_STR}_tend${TEND}.dat

print "EM\tOR\tIM\tIB" >${OUT}

for i in `seq 1 ${N}`; do
    
    # GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND 2>&1 >/dev/null | tail -n 1
    # More complicated in zsh than in bash, see:
    #
    # https://unix.stackexchange.com/questions/265061/how-can-i-pipe-only-stderr-in-zsh
    GSL_RNG_SEED=$i ${DIR}/psi $SPP $SPM $SMP $SMM 0 0 $TEND $P_APLUS 2>&1 >&- > /dev/null | tail -n 1 >> ${OUT}
done
