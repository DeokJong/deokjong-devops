{{- define "minecraft.namespace" -}}
{{- default .Release.Namespace .Values.namespace -}}
{{- end -}}

{{- define "minecraft.labels" -}}
app.kubernetes.io/name: minecraft
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "minecraft.hostname" -}}
{{- $server := required "serverName is required" .Values.serverName -}}
{{- $base := required "baseDomain is required" .Values.baseDomain -}}
{{- printf "%s.%s" $server $base -}}
{{- end -}}
