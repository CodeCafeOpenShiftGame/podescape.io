# Apache HTTP Server (httpd) S2I based hosting for PodEscape

This is a very basic application repository that builds and deploys PodEscape 
on [OpenShift](https://www.openshift.com) using the [Apache HTTP Server builder image](https://github.com/sclorg/httpd-container).

The application serves a single static html page via httpd which references the WebAssembly build of PodEscape.

Building and running PodEscape via a containerized http server will look similar to the following:
```
$ s2i build https://github.com/sclorg/httpd-ex centos/httpd-24-centos7 myhttpdimage
$ docker run -p 8080:8080 myhttpdimage
$ # browse to http://localhost:8080
```

Or for building on OpenShift:
`$ oc new-app centos/httpd-24-centos7~https://github.com/sclorg/httpd-ex`


To deploy the template into your project namespace:
`$ oc process -f ./openshift/templates/podescape-io-httpd.json | oc create -f -`
