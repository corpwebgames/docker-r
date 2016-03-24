#!/bin/bash

R CMD javareconf

R --no-save << EOF
install.packages(c('RCurl', 'XML', 'digest', 'RJDBC', 'doParallel', 'foreach', 'plyr', 'data.table'),
repos="http://cran.rstudio.com", INSTALL_opts=c('--byte-compile') )
EOF

aws s3 cp s3://webgames-emr/R/lib/RAmazonS3_0.1-5.tar.gz ./Rlib
sudo R --no-save << EOF
 install.packages(c('./Rlib/RAmazonS3_0.1-5.tar.gz'),repos=NULL, INSTALL_opts=c('--byte-compile'), Ncpus = 4 )
EOF
