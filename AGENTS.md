# Repository Guidelines

## Values Ownership

- Files under `charts/**/values.yaml` are template defaults only.
- Do not put environment-specific or real rendering values in `charts/**/values.yaml`.
- Real values for rendering live under `clusters/{clusterName}/**/values.yaml`.
- Cluster-wide values live in `clusters/{clusterName}/config.yaml`.
- If a value is different per cluster, domain, account, region, namespace, or application instance, put it under `clusters/{clusterName}/`, not under `charts/`.

## Cluster Chart Structure

- `charts/cluster` is the root reusable cluster chart.
- A cluster root Application, for example `clusters/sandbox/appset.yaml`, renders `charts/cluster`.
- `charts/cluster/templates/appset.yaml` creates an Argo CD `ApplicationSet`.
- The ApplicationSet discovers applications from `{{ .Values.global.basePath }}/**/values.yaml`.
- Each discovered cluster values file provides application metadata such as:
  - `appName`
  - `chartPath`
  - `releaseName`
  - `namespace`
  - `syncWave`

## Render Flow

- `clusters/{clusterName}/config.yaml` is passed to `charts/cluster`.
- The generated ApplicationSet renders each app using:
  - `$values/{basePath}/config.yaml`
  - `$values/{path-to-app}/values.yaml`
- This means child charts may read shared values from `.Values.global`, but those values come from `clusters/{clusterName}/config.yaml`, not from the child chart's own defaults.

## Chart Authoring Rules

- Keep chart defaults generic, empty, or safe placeholders.
- Prefer required checks in templates for values that must be supplied by cluster values.
- Do not hardcode real domains, hosted zone IDs, AWS regions, cluster names, repo URLs, app names, or namespaces in `charts/**/values.yaml`.
- If a chart needs reusable template logic only, place it under `charts/_library`.
- Library charts should not be registered as standalone Applications.
