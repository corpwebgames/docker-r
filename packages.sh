#!/bin/bash

sudo R --no-save << EOF
install.packages(c('RJDBC', 'doParallel', 'foreach', 'plyr', 'data.table'),
repos="http://cran.rstudio.com", INSTALL_opts=c('--byte-compile') )
EOF

sudo R --no-save << EOF
install.packages(c('RAmazonS3'),
repos="http://www.omegahat.org/R", INSTALL_opts=c('--byte-compile') )
EOF
