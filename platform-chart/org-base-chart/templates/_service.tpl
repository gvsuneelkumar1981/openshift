{{/*
==============================================
ORG BASE CHART - SERVICE
==============================================
*/}}

{{- define "base.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.app.name }}
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  selector:
    {{- include "base.selectorLabels" . | nindent 4 }}
  ports:
  - protocol: TCP
    port: 80
    targetPort: {{ .Values.app.port | default 8080 }}
{{- end }}