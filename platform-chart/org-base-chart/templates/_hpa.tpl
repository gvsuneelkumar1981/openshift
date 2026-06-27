{{/*
==============================================
ORG BASE CHART - HORIZONTAL POD AUTOSCALER
Enable by setting hpa.enabled=true
==============================================
*/}}
{{- define "base.hpa" -}}
{{- if .Values.hpa.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ .Values.app.name }}-hpa
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ .Values.app.name }}
  minReplicas: {{ .Values.hpa.minReplicas | default 1 }}
  maxReplicas: {{ .Values.hpa.maxReplicas | default 5 }}
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.hpa.cpuThreshold | default 70 }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ .Values.hpa.memoryThreshold | default 80 }}
{{- end }}
{{- end }}