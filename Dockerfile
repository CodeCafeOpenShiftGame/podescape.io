# PodEscape static site served by Red Hat's Hummingbird httpd image.
#
# The base image is shell-less: only COPY and metadata instructions are
# possible (no RUN, no s2i). It serves /var/www/html, which is a symlink to
# /usr/local/apache2/htdocs, as a non-root user (apache, uid/gid 48) on 8080.
#
# COPY --chmod is deliberate: the build context can be checked out with a
# restrictive umask (e.g. 0077), in which case the copied files would be
# unreadable by the non-root httpd user.
FROM registry.access.redhat.com/hi/httpd@sha256:c3ca35808208420f4797568a83e652f1c489ad2a91ed4eb34b0cab64470c2959

COPY --chown=48:0 --chmod=0644 index.html /usr/local/apache2/htdocs/index.html
COPY --chown=48:0 --chmod=0644 PodEscape.js PodEscape.wasm PodEscape.pck PodEscape.png \
     /usr/local/apache2/htdocs/
COPY --chown=48:0 --chmod=0644 httpd-cfg/podescape.conf \
     /etc/httpd/conf.d/podescape.conf
