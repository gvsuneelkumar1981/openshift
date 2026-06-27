{{/*
==============================================
ORG BASE CHART - VAULT DEPLOYMENT
NOTE: Skeleton reference only.
      In production Vault is managed
      separately by security team.
      Enable by setting vault.deploy=true
==============================================
*/}}
{{- define "base.vault" -}}
{{- if .Values.vault.deploy }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vault
  labels:
    app: vault
spec:
  replicas: 1
  selector:
    matchLabels:
      app: vault
  template:
    metadata:
      labels:
        app: vault
    spec:
      containers:
      - name: vault
        image: hashicorp/vault:1.15.0
        ports:
        - containerPort: 8200
        env:
        - name: VAULT_DEV_ROOT_TOKEN_ID
          value: {{ .Values.vault.token | default "myroot" }}
        - name: VAULT_DEV_LISTEN_ADDRESS
          value: "0.0.0.0:8200"
---
apiVersion: v1
kind: Service
metadata:
  name: vault
  labels:
    app: vault
spec:
  selector:
    app: vault
  ports:
  - port: 8200
    targetPort: 8200
{{- end }}
{{- end }}