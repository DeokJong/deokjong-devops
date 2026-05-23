{{- define "wildcard-tls.safeName" -}}
{{- . | toString | lower | replace "." "-" | replace "*" "wildcard" | trimSuffix "-" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "wildcard-tls.certificateName" -}}
{{- printf "%s-%s" .root.Values.name (include "wildcard-tls.safeName" .domain) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "wildcard-tls.secretName" -}}
{{- printf "%s-tls" (include "wildcard-tls.certificateName" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
