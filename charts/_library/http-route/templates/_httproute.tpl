{{- define "http-route.httproute" -}}
{{- $root := .root -}}
{{- $route := default dict .route -}}
{{- $gatewayType := default "public" $route.gatewayType -}}
{{- $gatewayOverride := default list $route.gatewayOverride -}}
{{- $backendRefs := required "route.backendRefs is required" $route.backendRefs -}}
{{- $redirect := default dict $route.redirect -}}
{{- if default true $route.enabled }}
{{- if and $gatewayOverride (not (kindIs "slice" $gatewayOverride)) }}
{{- fail "route.gatewayOverride must be a list of parentRefs" }}
{{- end }}
{{- if not (has $gatewayType (list "public" "private" "all")) }}
{{- fail "route.gatewayType must be one of: public, private, all" }}
{{- end }}
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: {{ include "http-route.name" (dict "root" $root "route" $route) | quote }}
  namespace: {{ include "http-route.namespace" (dict "root" $root "route" $route) | quote }}
spec:
  hostnames:
{{- range required "route.hostnames is required" $route.hostnames }}
    - {{ . | quote }}
{{- end }}
  parentRefs:
{{- if $gatewayOverride }}
{{- range $parentRef := $gatewayOverride }}
    - group: {{ default "gateway.networking.k8s.io" $parentRef.group | quote }}
      kind: {{ default "Gateway" $parentRef.kind | quote }}
      name: {{ required "route.gatewayOverride[].name is required" $parentRef.name | quote }}
      namespace: {{ default "gateway-system" $parentRef.namespace | quote }}
      sectionName: {{ default "https" $parentRef.sectionName | quote }}
{{- end }}
{{- else }}
{{- if or (eq $gatewayType "public") (eq $gatewayType "all") }}
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: "public-gateway"
      namespace: "gateway-system"
      sectionName: "https"
{{- end }}
{{- if or (eq $gatewayType "private") (eq $gatewayType "all") }}
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: "private-gateway"
      namespace: "gateway-system"
      sectionName: "https"
{{- end }}
{{- end }}
  rules:
    - matches:
{{ include "http-route.matches" (dict "root" $root "route" $route) | indent 8 }}
      {{- with $route.filters }}
      filters:
{{ toYaml . | indent 8 }}
      {{- end }}
      backendRefs:
{{- range $backendRef := $backendRefs }}
        - kind: {{ default "Service" $backendRef.kind | quote }}
          name: {{ required "route.backendRefs[].name is required" $backendRef.name | quote }}
          port: {{ required "route.backendRefs[].port is required" $backendRef.port }}
          {{- with $backendRef.weight }}
          weight: {{ . }}
          {{- end }}
{{- end }}
{{- if default true $redirect.enabled }}
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: {{ printf "%s-redirect" (include "http-route.name" (dict "root" $root "route" $route)) | trunc 63 | trimSuffix "-" | quote }}
  namespace: {{ include "http-route.namespace" (dict "root" $root "route" $route) | quote }}
spec:
  hostnames:
{{- range required "route.hostnames is required" $route.hostnames }}
    - {{ . | quote }}
{{- end }}
  parentRefs:
{{- if $gatewayOverride }}
{{- range $parentRef := $gatewayOverride }}
    - group: {{ default "gateway.networking.k8s.io" $parentRef.group | quote }}
      kind: {{ default "Gateway" $parentRef.kind | quote }}
      name: {{ required "route.gatewayOverride[].name is required" $parentRef.name | quote }}
      namespace: {{ default "gateway-system" $parentRef.namespace | quote }}
      sectionName: {{ default "http" $parentRef.httpSectionName | quote }}
{{- end }}
{{- else }}
{{- if or (eq $gatewayType "public") (eq $gatewayType "all") }}
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: "public-gateway"
      namespace: "gateway-system"
      sectionName: "http"
{{- end }}
{{- if or (eq $gatewayType "private") (eq $gatewayType "all") }}
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: "private-gateway"
      namespace: "gateway-system"
      sectionName: "http"
{{- end }}
{{- end }}
  rules:
    - matches:
{{ include "http-route.matches" (dict "root" $root "route" $route) | indent 8 }}
      filters:
        - type: RequestRedirect
          requestRedirect:
            scheme: https
            statusCode: {{ default 301 $redirect.statusCode }}
{{- end }}
{{- end }}
{{- end -}}
