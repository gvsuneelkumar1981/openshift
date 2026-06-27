{{/*
==============================================
ORG BASE CHART - ROUTE (OCP Specific)
==============================================
*/}}

{{- define "base.route" -}}
apiVersion: route.openshift.io/v1
kind: Route
metadata:
  name: {{ .Values.app.name }}
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  to:
    kind: Service
    name: {{ .Values.app.name }}
  port:
    targetPort: {{ .Values.app.port | default 8080 }}
{{- end }}