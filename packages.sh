#!/bin/bash

apt-get update && apt-get install -y libcurl4-openssl-dev apt-get install libxml2-dev libdigest-hmac-perl

R CMD javareconf

R --no-save << EOF
install.packages(c('RCurl', 'XML', 'digest', 'RJDBC', 'doParallel', 'foreach', 'plyr', 'data.table'),
repos="http://cran.rstudio.com", INSTALL_opts=c('--byte-compile') )
EOF

R --no-save << EOF
install.packages(c('RAmazonS3'),
repos="http://www.omegahat.org/R", INSTALL_opts=c('--byte-compile') )
EOF
