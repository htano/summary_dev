library(LiblineaR); library(e1071); library(SparseM);
#svmdata <- read.matrix.csr("tmp/auto_summarize/learning/train_data_binned.txt"); # some labels were changed manualy.
#svmdata <- read.matrix.csr("tmp/auto_summarize/learning/train_data_20130918.txt"); # auto labeling by make_liblinear
svmdata <- read.matrix.csr("tmp/auto_summarize/learning/train_data_20130920.txt"); # auto labeling by make_liblinear
tr.num <- 1:2000
y.tr <- as.numeric(svmdata$y[tr.num])
x.tr <- as.matrix(svmdata$x[tr.num])
s=scale(x.tr,center=TRUE,scale=TRUE)
co=heuristicC(s)
m=LiblineaR(data=s,labels=y.tr,type=1,cost=co,bias=FALSE,verbose=FALSE)

y.te <- as.numeric(svmdata$y[-tr.num])
x.te <- as.matrix(svmdata$x[-tr.num])
s2=scale(x.te,attr(s,"scaled:center"),attr(s,"scaled:scale"))
p=predict(m,s2,proba=FALSE,decisionValues=TRUE)

plot(p$decisionValues[,1], y.te)
cor.te <- cor(p$decisionValues[,1], y.te)

pos.scores <- p$decisionValues[,1][y.te==2]
neg.scores <- p$decisionValues[,1][y.te==1]
eval.num <- length(pos.scores)
auc <- mean(sample(pos.scores,eval.num,replace=T) < sample(neg.scores,eval.num,replace=T))

write(attr(s,"scaled:center"), file="scripts/auto_summarize/predict/params/feature_center.txt", sep="\n")
write(attr(s,"scaled:scale"), file="scripts/auto_summarize/predict/params/feature_scale.txt", sep="\n")
write(-m$W, file="scripts/auto_summarize/predict/params/feature_weights.txt", sep="\n")
