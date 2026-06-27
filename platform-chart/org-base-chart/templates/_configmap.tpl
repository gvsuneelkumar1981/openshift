{{/*
==============================================
ORG BASE CHART - CONFIGMAP
All non-sensitive config injected here.
Add new standard config keys here.
==============================================
*/}}

{{- define "base.configmap" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .Values.app.name }}-config
  labels:
    {{- include "base.labels" . | nindent 4 }}
data:
  LOG_LEVEL: {{ .Values.config.logLevel | default "INFO" }}
  APP_ENV: {{ .Values.config.appEnv | default "dev" }}
  MQ_HOST: {{ .Values.config.mqHost | default "localhost" }}
  KAFKA_BOOTSTRAP_SERVERS: {{ .Values.config.kafkaBootstrapServers | default "localhost:9092" }}
  MAINFRAME_HOST: {{ .Values.config.mainframeHost | default "localhost" }}
  # Vault connection — non sensitive
  VAULT_HOST: {{ .Values.vault.host | default "vault" }}
  VAULT_SERVER_PORT: {{ .Values.vault.port | default "8200" | quote }}
  VAULT_MOUNT_PATH: {{ .Values.vault.mountPath | default "myapp/secret" }}
  VAULT_PATH: {{ .Values.vault.path | default "order-service/dev" }}
{{- end }}