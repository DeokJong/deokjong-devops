{{- define "common.labels" -}}
app.kubernetes.io/name: whoami
{{- end -}}

{{- define "common.namespace" -}}
{{- default .Release.Namespace .Values.namespace -}}
{{- end -}}

{{- define "common.appName" -}}
whoami
{{- end -}}
