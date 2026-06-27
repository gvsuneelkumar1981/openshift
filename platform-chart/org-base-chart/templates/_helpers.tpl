{{/*
==============================================
ORG BASE CHART - HELPERS
Maintained by: Platform Team
==============================================
*/}}

{{/* Standard org labels */}}
{{- define "base.labels" -}}

app: {{ .Values.app.name }}
version: {{ .Values.app.tag | default "latest" }}
app.kubernetes.io/name: {{ .Values.app.name }}
app.kubernetes.io/version: {{ .Values.app.tag | default "latest" }}
app.kubernetes.io/managed-by: Helm
org/team: {{ .Values.app.team | default "unknown" }}
org/env: {{ .Values.config.appEnv | default "dev" }}
{{- end }}

{{/*
Standard selector labels
*/}}
{{- define "base.selectorLabels" -}}
app: {{ .Values.app.name }}
{{- end }}