#!/bin/zsh

# Replace '.' with 0
SPP=$1
SPP="${"${SPP//0./0}"//./0}"

SPM=$2
SPM="${"${SPM//0./0}"//./0}"

SMP=$3
SMP="${"${SMP//0./0}"//./0}"

SMM=$4
SMM="${"${SMM//0./0}"//./0}"

BP=$5
BP="${BP:-0}"
BP="${"${BP//0./0}"//./0}"

BN=$6
BN="${BN:-0}"
BN="${"${BN//0./0}"//./0}"

TEND=$7

DIR=~/c/PSI
OUT=plots/PSI_spp${SPP}_spm${SPM}_smp${SMP}_smm${SMM}_bp${BP}_bn${BN}_tend${TEND}

gnuplot -persist <<EOF

tend=${TEND}

set xrange [0:tend]
set yrange [0:4.5]

set xlabel "time"
set ylabel "Activity"

set grid

# set linestyle 1 lt rgb "green"
# set linestyle 2 lt rgb "blue"
# set linestyle 3 lt 3
# set linestyle 4 lt rgb "dark-green"

set linestyle 1 lt rgb "dark-yellow"
set linestyle 2 lt rgb "light-blue"
set linestyle 3 lt rgb "red"
set linestyle 4 lt rgb "green"

set linestyle 5 lt rgb "dark-green"
set linestyle 6 lt rgb "blue"

set term x11 0

# unset key

plot "< ./psi $1 $2 $3 $4 $5 $6 $7" u 1:2 t col(2) w l ls 1, "" u 1:3 t col(3) w l ls 2, "" u 1:4 t col(4) w l ls 3, "" u 1:5 t col(5) w l ls 4, "" u 1:10 not w l ls 5, "" u 1:11 not w l ls 6

#, "" u 1:6 not w l ls 5, "" u 1:7 not w l ls 6

set term post colour solid "Times-Roman" 24 lw 3
set out "${DIR}/${OUT}.ps"
rep

#set term x11 1
set yrange [0:2.5]
# plot "< ./psi $1 $2 $3 $4 $5 $6 $7" u 1:8 t col(8) w l, "" u 1:9 t col(9) w l
#plot "< ./psi $1 $2 $3 $4 $5 $6 $7" u 1:12 t col(12) w l, "" u 1:13 t col(13) w l

EOF

ps2eps -f -B -l -rotate=+ ${DIR}/${OUT}.ps
epstopdf ${DIR}/${OUT}.eps
