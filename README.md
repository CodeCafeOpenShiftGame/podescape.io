# PodEscape static site (Apache httpd on OpenShift)

Static hosting for the Godot WebAssembly build of PodEscape.

The site is served by Red Hat's Hummingbird image
(`registry.access.redhat.com/hi/httpd`), which runs as a non-root user on port
8080 and contains no shell. The image is built from this repository's
`Dockerfile`; there is no s2i build step and no build-time templating.

## Build and run locally

```sh
docker build -t podescape-io .
docker run --rm -p 8080:8080 podescape-io
# browse to http://localhost:8080
```

## Deploy on OpenShift

Create the objects once:

```sh
oc process -f openshift/templates/podescape-io-httpd.json | oc apply -f -
```

The template creates:

- a `BuildConfig` using the **Docker** strategy (`Dockerfile` at the repo root),
- the `${NAME}:latest` output `ImageStream`,
- a `Deployment`, `Service` and `Route` (port 8080).

Start the first build:

```sh
oc start-build podescape-io --follow
```

The build pulls the commit from `SOURCE_REPOSITORY_URL` (default
`https://github.com/CodeCafeOpenShiftGame/podescape.io.git`) and builds this
repository's `Dockerfile` inside the cluster. GitHub and generic webhook
triggers are configured, so a push can start a build automatically; use
`oc get bc podescape-io -o jsonpath='{.spec.triggers}'` to inspect the secrets
and `oc describe bc podescape-io` for the webhook URLs.

A new image on `podescape-io:latest` triggers a rollout through the
`image.openshift.io/triggers` annotation on the `Deployment`.

## Requirements and operational notes

- OpenShift 4.12 or newer: the in-cluster buildah must support `COPY --chmod`,
  which the `Dockerfile` uses to keep files readable by the non-root user.
- The build pod must be able to pull `registry.access.redhat.com/hi/httpd`.
  On a disconnected cluster, mirror the image and update the digest in
  `Dockerfile` (the `FROM` is pinned by digest).
- The runtime image is shell-less, so `oc rsh` will not give you a shell. Use
  `oc logs` (httpd already writes access/error logs to stdout/stderr), or
  `oc debug --image=registry.access.redhat.com/ubi9/ubi-minimal` when you need
  interactive tooling.
- `.pck` is served as `application/octet-stream` by
  `httpd-cfg/podescape.conf`; `.wasm` is already mapped by the base image.

## License

Apache License 2.0. See `LICENSE`.
