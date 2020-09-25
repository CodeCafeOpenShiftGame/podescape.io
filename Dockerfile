FROM registry.redhat.io/rhscl/httpd-24-rhel7

USER 0
ADD . /tmp/src/
RUN chown -R 1001:0 /tmp/src
USER 1001

# This leverages s2i built into the base image
RUN /usr/libexec/s2i/assemble
CMD /usr/libexec/s2i/run

# ------
# If we don't need s2i we could just do something like this
# and also we could use centos if we don't have access to Red Hat's registry
# FROM centos/httpd-24-centos7
# ADD index.html /var/www/html/index.html
# CMD run-httpd
