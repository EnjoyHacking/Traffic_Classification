---
title       : Traffic Classification
subtitle    : Research into the Area of Security
author      : Yinsen Miao
job         : Master in Statistics
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
logo        : Rice-University.png
hitheme     : tomorrow      # 
widgets     : [mathjax, quiz, bootstrap]            # 
ext_widgets: {rCharts: [libraries/nvd3]}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Dataset

| Name     | Year 	| Dimension 	| Labeled 	| Raw  	| Description 	|
|:---------------------------------------------------------------------:	|-----------	|:---------:	|:-------:	|:-------:	|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| [WIDE](http://mawi.wide.ad.jp/mawi/) 	| 2006-2014 	| >>1B 	| No 	| Yes 	| Daily 15-minute traffic trace collected by US-JP backbone network and has been [anonymized](http://mawi.wide.ad.jp/mawi/guideline.txt) by deleting payload. But might be useful.   	|
| [CAIDA](http://www.caida.org/data/overview/) 	| 2008-2014 	| >>1B 	| No 	| Yes 	| Monthly anonymized traffic traces from the "equinix-chicago" and "equinix-sanjose" high-speed monitors. But might be useful for unsupervised learning. 	|
| [WITS](http://wand.net.nz/wits/) 	| 2002-2010 	| >>1B 	| No 	| Yes 	| Cannot be downloaded via IPv4 network. 	|
| [LBNL/ICSI](http://www.icir.org/enterprise-tracing/download.html) 	| 2004 	| >>10K 	| No 	| Yes 	| Anonymized traffic traces 	|
| [UPC-CCABA](http://loadshedding.ccaba.upc.edu/traffic_classification) 	| 2013 	| >1B 	| Yes 	| Unknown 	| 535K of the flows are labeled. The dataset is already requested pending to download. 	|
| [UNIBS](http://www.ing.unibs.it/ntw/tools/traces/) 	| 2009 	| 78K 	| Yes 	| Yes 	| Traffic collected from a subnet of 20 hosts used by students and dept. personnel, anonymized but with associated ground truth metadata, collected with the [GT tool](http://www.ing.unibs.it/ntw/tools/gt/). 	|


--- #id1
## Resource Paper
[A summary of papers (1994-2009) from CAIDA](http://www.caida.org/research/traffic-analysis/classification-overview/)

--- #id2

## OMP performance (Accuracy)




<img src="assets/fig/unnamed-chunk-2.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />

---

## OMP performance (Time comsumption)
<img src="assets/fig/unnamed-chunk-3.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />

---

## Paper about on-line learning
[On-line SVM traffic classification](https://www.dropbox.com/s/e4vfp6mamaca3ri/2011-On-line%20SVM%20traffic%20classification.pdf)
>
* Parallelized optimized SVM on [CoMo](http://como.sourceforge.net/index.php) platform.
* C source code implemented in SVM, Naived Bayes [available](http://www.ing.unibs.it/ntw/tools/como-modules/)
* Dataset used [UNIBS (labeled)](http://www.ing.unibs.it/ntw/tools/traces/), [AUCK](http://wand.net.nz/wits/), [MAWI](http://mawi.wide.ad.jp/mawi/), [CAIDA](http://www.caida.org/data/overview/).
* Mainly talked about CPU time and memory comsumption but didn't mention their accuracy performance or even how they manage to train their supervised SVM on unlabeled dataset.  



