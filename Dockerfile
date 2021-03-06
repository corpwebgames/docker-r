FROM dpatriot/docker-s3-runner:1.4.0

MAINTAINER Shago Vyacheslav <v.shago@corpwebgames.com>

## Set a default user. Available via runtime flag `--user docker` 
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly). 
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
		software-properties-common \
        ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
    && add-apt-repository -y "ppa:marutter/rrutter" \
	&& add-apt-repository -y "ppa:marutter/c2d4u" \
    && apt-get update 

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
## Note 1: we need wget here as the build env is too old to work with libcurl (we think, precise was)
## Note 2: r-cran-docopt is not currently in c2d4u so we install from source
RUN apt-get install -y --no-install-recommends \
        r-cran-littler \
		r-base \
		r-base-dev \
		r-recommended \
        r-cran-stringr \
        libcurl4-openssl-dev \
        libxml2-dev \
        libdigest-hmac-perl \
    && echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "wget")' >> /etc/R/Rprofile.site \
	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# install required packages
COPY packages.sh /opt/packages.sh
COPY RAmazonS3_0.1-5.tar.gz /opt/RAmazonS3_0.1-5.tar.gz
RUN chmod +x /opt/packages.sh
RUN /opt/packages.sh

# install drivers
RUN curl -s https://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC41-1.1.10.1010.jar -o /usr/lib/R/lib/RedshiftJDBC41.jar \
	&& curl -s http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.38/mysql-connector-java-5.1.38.jar -o /usr/lib/R/lib/mysql-connector-java.jar

ENV JDBC_PATH /usr/lib/R/lib/mysql-connector-java.jar
ENV REDSHIFT_JDBC_PATH /usr/lib/R/lib/RedshiftJDBC41.jar
