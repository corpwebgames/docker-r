#!/bin/bash

sudo R --no-save << EOF
install.packages(c('RJDBC', 'doParallel', 'foreach', 'plyr', 'RAmazonS3', 'data.table'),
repos="http://cran.rstudio.com", INSTALL_opts=c('--byte-compile') )
EOF
