{{- define "http-route.name" -}}
{{- default .root.Release.Name .route.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "http-route.namespace" -}}
{{- default (default .root.Release.Namespace .root.Values.namespace) .route.namespace -}}
{{- end -}}

{{- define "http-route.matches" -}}
{{- toYaml (default (list (dict "path" (dict "type" "PathPrefix" "value" "/"))) .route.matches) -}}
{{- end -}}
