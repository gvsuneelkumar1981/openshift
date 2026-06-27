{{/*
==============================================
ORG BASE CHART - EXTERNAL SECRET
NOTE: This is ESO approach skeleton.
      Currently using Spring Cloud Vault.
      Enable by setting vault.useESO=true
==============================================
*/}}
{{- define "base.externalsecret" -}}
{{- if .Values.vault.useESO }}
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: {{ .Values.app.name }}-secret
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  refreshInterval: {{ .Values.vault.refreshInterval | default "1h" }}
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: {{ .Values.app.name }}-secret
    creationPolicy: Owner
  data:
  - secretKey: DB_PASSWORD
    remoteRef:
      key: {{ .Values.vault.path }}
      property: db_password
  - secretKey: MQ_PASSWORD
    remoteRef:
      key: {{ .Values.vault.path }}
      property: mq_password
  - secretKey: API_KEY
    remoteRef:
      key: {{ .Values.vault.path }}
      property: api_key
{{- end }}
{{- end }}