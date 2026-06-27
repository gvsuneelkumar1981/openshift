{{/*
==============================================
ORG BASE CHART - SECRET STORE
NOTE: ESO skeleton reference only.
      Enable by setting vault.useESO=true
==============================================
*/}}
{{- define "base.secretstore" -}}
{{- if .Values.vault.useESO }}
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: vault-backend
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  provider:
    vault:
      server: {{ .Values.vault.server | default "http://vault:8200" }}
      path: {{ .Values.vault.mountPath | default "myapp/secret" }}
      version: "v2"
      auth:
        tokenSecretRef:
          name: vault-token-secret
          key: token
{{- end }}
{{- end }}