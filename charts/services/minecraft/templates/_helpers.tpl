{{- define "minecraft.namespace" -}}
{{- default .Release.Namespace .Values.namespace -}}
{{- end -}}

{{- define "minecraft.labels" -}}
app.kubernetes.io/name: minecraft
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
