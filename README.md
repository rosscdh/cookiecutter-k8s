# Generator for kubernetes

A simple cookiecutter.io generator for a k8s manifest for your application.

Generally skaffold.dev is used to deploy your application the the cluster sandbox providing you with a fast efficient way of getting your apps onto the `sandbox` namespace in your kubernetes cluster.
Whereas for staging and above we rely on github actions to build test and render your application.


```
                                       Ingress based
                                       on branch name   ┌────┬─────────────────────────┬────┐
                                                        │    │                         │    │
                                     ┌──────────────────┼───►│                         │    │
                                     │                  │    │   Sandbox namespace     │    │
                                     │                  │    │                         │    │
            Runs on local     ┌──────┴──────┐           │    │                         │    │
            Branch            │             │           │    │                         │    │
            ┌────────────────►│             │           │    └─────────────────────────┘    │
            │                 │             │           │                                   │
            │                 │ skaffold    │           │                                   │
            │1.               │             │           │        Kubernetes Cluster         │
            │                 │             │           │                                   │
      ┌─────┴────────┐        │             │           │                                   │
      │              │        └─────────────┘           │    ┌─────────────────────────┐    │
      │              │                                  │    │                         │    │
      │              │        ┌─────────────┐           │    │                         │    │
      │ Developer    │        │             ├───────────┼───►│   Staging Namespace     │    │
      │              │        │             │           │    │                         │    │
      │              │        │             │           │    │                         │    │
      │              │        │ skaffold    │           │    │                         │    │
      └──────┬───────┘        │             │           │    ├─────────────────────────┤    │
             │                │             │           │    │                         │    │
             │2.              │             ├───────────┼───►│                         │    │
             │                └──────▲──────┘           │    │                         │    │
             │                       │                  │    │   Production Namespace  │    │
Push to      │                ┌──────┴──────┐           │    │                         │    │
staging/X    │                │             │           │    │                         │    │
production/X │                │             │           └────┴─────────────────────────┴────┘
             │                │  Github     │
             │                │  ACtions    │
             └───────────────►│             │
                              │             │
                              │             │
                              └─────────────┘
```

## Provides

1. `k8s/` - folder of kustomize for your application and 3 env
2. `.github/` - github actiions that can be used to render your code out to an argocd application repo for deployment
3. `skaffold.yaml` - skaffold file for building running testing and deploying your kubernetes application, is also used in the `.github` actions
4. `Dockerfile` - std multi stage dockerfile
5. `Caddyfile` - caddy is a simple high speed proxy useful for django or similar apps that need static access to rendered assets, css and js

## Usage

```
cd k8s-src-generator          # cd into the folder
make setup                    # install cookiecutter
make generate                 # generate your source
# copy output/project_slug into your application
# configure the k8s/base/deployment.yaml to have your application settings and startup config
# use overlays/{staging,production,sandbox} edit the kustomization.yaml and set config and secrets
# secrets will deprecate and become external secrets
```


## Using Skaffold

Development local, will startup and build the initial and depoy it to `sandbox`

```
 skaffold dev --profile sandbox
```

Render the manifest for you to review

```
 skaffold render  --offline=true --profile sandbox
```