prefsDat <- c("AUC_PSI_spp1025_spm045_smp075_smm075_bp0_bn0_",
           "AUC_PSI_spp045_spm1025_smp075_smm075_bp0_bn0_",
           "AUC_PSI_spp075_spm075_smp045_smm1025_bp0_bn0_",
           "AUC_PSI_spp075_spm075_smp1025_smm045_bp0_bn0_")

typesDat <- c("agreeable", "independent", "self-determined", "conscientious")

sufP05 <- "prAplus05_tend1000.dat"

# Compiles data of personality types with prefixes prefs and typenames
# and one common suffix
readPTtypes <- function(prefs, typenames, suf) {
    fn <- sprintf("%s%s", prefs[1], suf)
    data <- read.table(fn, header=TRUE, sep="\t")
    data$type <- typenames[1]

    if(length(prefs)<=1) return(data)
    
    for(i in 2:length(prefs)) {
        fn <- sprintf("%s%s", prefs[i], suf)
        datType <- read.table(fn, header=TRUE, sep="\t")
        datType$type <- typenames[i]
        data <- rbind(data, datType)
    }
    return (data)
}

datp05 <- readPTtypes(prefs=prefsDat, typenames=typesDat, suf=sufP05)
datp05

sufP07 <- "prAplus07_tend1000.dat"
datp07 <- readPTtypes(prefs=prefsDat, typenames=typesDat, suf=sufP07)
datp07

sufP09 <- "prAplus09_tend1000.dat"
datp09 <- readPTtypes(prefs=prefsDat, typenames=typesDat, suf=sufP09)
datp09

sufP03 <- "prAplus03_tend1000.dat"
datp03 <- readPTtypes(prefs=prefsDat, typenames=typesDat, suf=sufP03)
datp03

sufP01 <- "prAplus01_tend1000.dat"
datp01 <- readPTtypes(prefs=prefsDat, typenames=typesDat, suf=sufP01)
datp01

###

datp01$pAplus <- 0.1
datp03$pAplus <- 0.3
datp05$pAplus <- 0.5
datp07$pAplus <- 0.7
datp09$pAplus <- 0.9

dataComplete <- rbind(
    datp01,
    datp03,
    datp05,
    datp07,
    datp09
)
dataComplete

subset(dataComplete, select=c("pAplus", "EM"), subset=type=="conscientious")

EMactivityMeans <- aggregate(EM ~ type + pAplus, data=dataComplete, FUN="mean")

EMactivityMeans

EMactivityMatrix <- as.data.frame(split(EMactivityMeans[,3], EMactivityMeans$type), check.names=FALSE)

EMactivitySD <- aggregate(IM ~ type + pAplus, data=dataComplete, FUN="sd")

EMactivitySD

EMactivitySDmat <- as.data.frame(split(EMactivitySD[,3], EMactivitySD$type), check.names=FALSE)

matplot(unique(EMactivitySD$pAplus),EMactivitySDmat, type="b")

# Plot
dev.new()

matplot(x=c(0.1,0.3,0.5,0.7,0.9),EMactivityMatrix, type="l", lty="solid",
        xlim=c(0,1), ylim=c(-0.4,0.4))

# Plot EM for all types
dev.new()
plot(
    subset(EMactivityMeans, select=c(pAplus, EM), subset=type ==unique(EMactivityMeans$type)[1]),
    type="l", xlim=c(0,1), ylim=c(-0.4,0.4)
    )
for(ty in unique(EMactivityMeans$type)[-1]) {
    lines(
        subset(EMactivityMeans, select=c(pAplus, EM), subset=type ==ty)
    )
}

for( p in unique(dataComplete$pAplus) ) {
    boxplot(subset(dataComplete, select=EM, subset=type=="agreeable" & pAplus==p),
            at=p, add=TRUE, boxwex=0.1, xaxt="n")
}

### Function for generating arbitrary plots of system activity for
### different personality types against pAplus.
plotSystemActivities <- function(data, types, syst="EM", col=seq_along(types)+1,
                                 ...) {
    EMactivityMeans <- aggregate(
        as.formula(sprintf("%s ~ type + pAplus", syst)),
        data=data, FUN="mean")

    plot(
        subset(EMactivityMeans, select=c("pAplus", syst), subset=type ==types[1]),
        type="l", xlim=c(0,1), ylim=c(-0.4,0.4), col=col[1], ...
    )
    for( p in unique(data$pAplus) ) {
        boxplot(subset(data, select=syst, subset=type==types[1] & pAplus==p),
                at=p, add=TRUE, boxwex=0.1, xaxt="n", col= col[1], ...)
    }
    i <- 2
    for(ty in types[-1]) {
        lines(
            subset(EMactivityMeans, select=c("pAplus", syst), subset=type ==ty),
            col =col[i], ...
        )
        for( p in unique(data$pAplus) ) {
            boxplot(subset(data, select=syst, subset=type==ty & pAplus==p),
                    at=p, add=TRUE, boxwex=0.1, xaxt="n", yaxt="n", col=col[i], ...)
        }
        i <- i+1
    }
    ## legend("bottomright", legend=types, col=col,
    ##        lty="solid")
}

AG.col <- "green"
IN.col <- "red"
CS.col <- "blue"
SD.col <- "yellow"

plotSystemActivities(dataComplete, types=unique(dataComplete$type),syst="OR",
                     xlab=expression(p["A"^"+"]))

plotSystemActivities(dataComplete, types=c("agreeable", "independent"), syst="IM", col=c(AG.col, IN.col))

### Object Recognition (IB)

pdf("ObjectRecognition_pAplus_agreeable_independent.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("agreeable", "independent"),
                     syst="OR",
                     xlab=expression(p["A"^"+"]),
                     col=c(AG.col, IN.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomleft", legend=c("agreeable", "independent"),
       col=c(AG.col, IN.col),lty="solid",
       cex=1.2)
dev.off()

pdf("ObjectRecognition_pAplus_conscientious_self-determined.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("self-determined", "conscientious"),
                     syst="OR",
                     xlab=expression(p["A"^"+"]),
                     col=c(SD.col, CS.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomleft", legend=c("self-determined", "conscientious"),
       col=c(SD.col, CS.col),lty="solid",
       cex=1.2)
dev.off()


###


### Extension Memory (EM)

pdf("ExtensionMemory_pAplus_agreeable_independent.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("agreeable", "independent"),
                     syst="EM",
                     xlab=expression(p["A"^"+"]),
                     col=c(AG.col, IN.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomright", legend=c("agreeable", "independent"),
       col=c(AG.col, IN.col),lty="solid",
       cex=1.2)
dev.off()

pdf("ExtensionMemory_pAplus_conscientious_self-determined.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("self-determined", "conscientious"),
                     syst="EM",
                     xlab=expression(p["A"^"+"]),
                     col=c(SD.col, CS.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomright", legend=c("self-determined", "conscientious"),
       col=c(SD.col, CS.col),lty="solid",
       cex=1.2)
dev.off()


###


### Intuitive Behaviour (IB)

pdf("IntuitiveBehaviour_pAplus_agreeable_independent.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("agreeable", "independent"),
                     syst="IB",
                     xlab=expression(p["A"^"+"]),
                     col=c(AG.col, IN.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomright", legend=c("agreeable", "independent"),
       col=c(AG.col, IN.col),lty="solid",
       cex=1.2)
dev.off()

pdf("IntuitiveBehaviour_pAplus_conscientious_self-determined.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("self-determined", "conscientious"),
                     syst="IB",
                     xlab=expression(p["A"^"+"]),
                     col=c(SD.col, CS.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomright", legend=c("self-determined", "conscientious"),
       col=c(SD.col, CS.col),lty="solid",
       cex=1.2)
dev.off()


### Intention memory (IM)

pdf("IntentionMemory_pAplus_agreeable_independent.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("agreeable", "independent"),
                     syst="IM",
                     xlab=expression(p["A"^"+"]),
                     col=c(AG.col, IN.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomleft", legend=c("agreeable", "independent"),
       col=c(AG.col, IN.col),lty="solid",
       cex=1.2)
dev.off()

pdf("IntentionMemory_pAplus_conscientious_self-determined.pdf")
par(mar=c(5.1,5.1,4.1,2.1), cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
plotSystemActivities(dataComplete, types=c("self-determined", "conscientious"),
                     syst="IM",
                     xlab=expression(p["A"^"+"]),
                     col=c(SD.col, CS.col)
                                        #cex=1.5,cex.axis=2,cex.lab=2, lwd=1.5
                     )
legend("bottomleft", legend=c("self-determined", "conscientious"),
       col=c(SD.col, CS.col),lty="solid",
       cex=1.2)
dev.off()

###

plotSystemActivities(dataComplete, types=c("conscientious", "self-determined"))


legend("bottomright", legend=c("conscientious", "self-determined"), col=2:3, lty=1)

###################################

boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="agreeable") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green")
)

pdf("Agreeable_pAplus05.pdf")
par(mar=c(5.1,4.5,4.1,2.1),
    cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="agreeable") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green"), yaxt="n", ylab="activity"
)
axis(side=2, at=c(-0.2,0,0.2))
dev.off()


boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="self-determined") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green")
)

pdf("SelfDetermined_pAplus05.pdf")
par(mar=c(5.1,4.5,4.1,2.1),
    cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="self-determined") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green"), yaxt="n", ylab="activity"
)
axis(side=2, at=c(-0.2,0,0.2))
dev.off()


boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="conscientious") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green") 
)

pdf("Conscientious_pAplus05.pdf")
par(mar=c(5.1,4.5,4.1,2.1),
    cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="conscientious") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green"), yaxt="n", ylab="activity"
)
axis(side=2, at=c(-0.2,0,0.2))
dev.off()


boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="independent") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green")
)

pdf("Independent_pAplus05.pdf")
par(mar=c(5.1,4.5,4.1,2.1),
    cex=1.2, cex.axis=1.75, cex.lab=1.75, lwd=1.5)
boxplot(
subset(dataComplete, select=c(EM, OR, IM,IB),
       subset=(type=="independent") & (pAplus==0.5)),
col=c("yellow", "blue", "red", "green"), yaxt="n", ylab="activity"
)
axis(side=2, at=c(-0.2,0,0.2))
dev.off()


###

split(
    subset(dataComplete, select=c(pAplus,EM), subset=type=="agreeable"),
    dataComplete$pAplus
)

boxplot(x=#data.frame(
    subset(dataComplete, select=c(pAplus,EM), subset=type=="agreeable")[[1]],
    subset(datp03, select=EM, subset=type=="agreeable")[[1]],
    subset(datp05, select=EM, subset=type=="agreeable")[[1]],
    subset(datp07, select=EM, subset=type=="agreeable")[[1]],
    subset(datp09, select=EM, subset=type=="agreeable")[[1]]
), at=c(0.1,0.3, 0.5,0.7,0.9), add=TRUE, boxwex=0.1, xaxt="n"
)
###


boxplot(split(datp05$EM, datp01$type),main="EM", ylim=c(-0.4,0.4))
dev.new()
boxplot(split(datp07$EM, datp01$type),main="EM", ylim=c(-0.4,0.4))


## Linear relationship between affect bias and AUCs
##
EMactmatrix <- rbind(
sapply(split(datp01$EM, datp01$type), mean),
sapply(split(datp03$EM, datp03$type), mean),
sapply(split(datp05$EM, datp05$type), mean),
sapply(split(datp07$EM, datp07$type), mean),
sapply(split(datp09$EM, datp09$type), mean)
)

dev.new()

### Show linear slope for types with same slope
matplot(c(0.1,0.3,0.5,0.7,0.9),EMactmatrix, type="b",
        xlim=c(0,1), ylim=c(-0.4,0.4),
        xlab=expression(p["A"^"+"]), ylab="activity", lty="solid")

boxplot(x=data.frame(
    subset(datp01, select=EM, subset=type=="agreeable")[[1]],
    subset(datp03, select=EM, subset=type=="agreeable")[[1]],
    subset(datp05, select=EM, subset=type=="agreeable")[[1]],
    subset(datp07, select=EM, subset=type=="agreeable")[[1]],
    subset(datp09, select=EM, subset=type=="agreeable")[[1]]
), at=c(0.1,0.3, 0.5,0.7,0.9), add=TRUE, boxwex=0.1, xaxt="n"
)

boxplot(x=data.frame(
    subset(datp01, select=EM, subset=type=="independent")[[1]],
    subset(datp03, select=EM, subset=type=="independent")[[1]],
    subset(datp05, select=EM, subset=type=="independent")[[1]],
    subset(datp07, select=EM, subset=type=="independent")[[1]],
    subset(datp09, select=EM, subset=type=="independent")[[1]]
), at=c(0.1,0.3, 0.5,0.7,0.9), add=TRUE, boxwex=0.1, xaxt="n", col="green"
)

####

boxplot(split(datp01$EM, datp01$type)[1], at=0.1, boxwex=0.2, add=TRUE)

## Linear slopes
(EMactmatrix[5,]-EMactmatrix[1,])/(0.9-0.1)

round((EMactmatrix[5,]-EMactmatrix[1,])/(0.9-0.1), 3)

boxplot( list(datp01$EM, datp03$EM), at=c(0.1,0.3), boxwex=0.2)


boxplot(list(
    subset(datp01, select=EM, subset=type=="agreeable")[[1]],
    subset(datp03, select=EM, subset=type=="agreeable")[[1]]
), at=c(0.1,0.3)
)

##
ORactmatrix <- rbind(
sapply(split(datp01$OR, datp01$type), mean),
sapply(split(datp03$OR, datp03$type), mean),
sapply(split(datp05$OR, datp05$type), mean),
sapply(split(datp07$OR, datp07$type), mean),
sapply(split(datp09$OR, datp09$type), mean)
)

matplot(c(0.1,0.3,0.5,0.7,0.9),ORactmatrix, type="l"
)

## Linear slopes
(ORactmatrix[5,]-ORactmatrix[1,])/(0.9-0.1)
round((ORactmatrix[5,]-ORactmatrix[1,])/(0.9-0.1), 3)


##
IMactmatrix <- rbind(
sapply(split(datp01$IM, datp01$type), mean),
sapply(split(datp03$IM, datp03$type), mean),
sapply(split(datp05$IM, datp05$type), mean),
sapply(split(datp07$IM, datp07$type), mean),
sapply(split(datp09$IM, datp09$type), mean)
)

matplot(c(0.1,0.3,0.5,0.7,0.9),IMactmatrix, type="l"
)

## Linear slopes
(IMactmatrix[5,]-IMactmatrix[1,])/(0.9-0.1)
round((IMactmatrix[5,]-IMactmatrix[1,])/(0.9-0.1), 3)

##
IBactmatrix <- rbind(
sapply(split(datp01$IB, datp01$type), mean),
sapply(split(datp03$IB, datp03$type), mean),
sapply(split(datp05$IB, datp05$type), mean),
sapply(split(datp07$IB, datp07$type), mean),
sapply(split(datp09$IB, datp09$type), mean)
)

matplot(c(0.1,0.3,0.5,0.7,0.9),IBactmatrix, type="b"
)

## Linear slopes
(IBactmatrix[5,]-IBactmatrix[1,])/(0.9-0.1)
round((IBactmatrix[5,]-IBactmatrix[1,])/(0.9-0.1),3)

###

data  <- read.table("AUC_PSI_spp1025_spm045_smp075_smm075_bp0_bn0_prAplus05_tend1000.dat", header=TRUE, sep="\t")

hist(data$EM)
dev.new()
hist(data$OR)
dev.new()
hist(data$IM)
dev.new()
hist(data$IB)

colMeans(data)

boxplot(data)

data$type<-"agreeable"


data.IN <- read.table("AUC_PSI_spp045_spm1025_smp075_smm075_bp0_bn0_prAplus05_tend1000.dat", header=TRUE, sep="\t")

data.IN$type <- "independent"

data.IN


data <- rbind(data,data.IN)

data.SD <- read.table("AUC_PSI_spp075_spm075_smp045_smm1025_bp0_bn0_prAplus05_tend1000.dat", header=TRUE, sep="\t")

data.SD$type <- "self-determined"

data.SD


data <- rbind(data,data.SD)

data.CS <- read.table("AUC_PSI_spp075_spm075_smp1025_smm045_bp0_bn0_prAplus05_tend1000.dat", header=TRUE, sep="\t")
data.CS$type <- "conscientious"

data.CS


data <- rbind(data,data.CS)

boxplot(split(data$EM, data$type),main="EM", ylim=c(-0.4,0.4))
dev.new()
boxplot(split(data$OR, data$type),main="OR", ylim=c(-0.4,0.4))
dev.new()
boxplot(split(data$IM, data$type),main="IM", ylim=c(-0.4,0.4))
dev.new()
boxplot(split(data$IB, data$type),main="IB", ylim=c(-0.4,0.4))

library("ggplot2")
library("reshape2")

data.long <- melt(data, id="type")

ggplot(data.long, aes(x = variable, y = value, color = type)) +  # ggplot function
  geom_boxplot()

### Prob07
