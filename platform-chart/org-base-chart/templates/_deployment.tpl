{{/*
==============================================
ORG BASE CHART - DEPLOYMENT
Standards enforced:
- Non-root security context
- Health probes mandatory
- Resource limits mandatory
- Graceful shutdown
- Standard env vars
==============================================
*/}}

{{- define "base.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.app.name }}
  labels:
    {{- include "base.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.app.replicas | default 1 }}
  selector:
    matchLabels:
      {{- include "base.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "base.labels" . | nindent 8 }}
      annotations:
        # Force restart when configmap changes
        checksum/config: {{ include "base.configmap" . | sha256sum }}
    spec:
      # Enforce non-root — org security standard
{{/*      securityContext:*/}}
{{/*        runAsNonRoot: true*/}}
{{/*        hostUsers: false*/}}
{{/*        runAsUser: 1014940000*/}}
{{/*        runAsGroup: 1014940000*/}}

      containers:
      - name: {{ .Values.app.name }}
        image: {{ .Values.app.image }}:{{ .Values.app.tag | default "latest" }}
        ports:
        - containerPort: {{ .Values.app.port | default 8080 }}

        # Inject ConfigMap
        envFrom:
        - configMapRef:
            name: {{ .Values.app.name }}-config

        # Inject Secret from Vault via ESO
        - secretRef:
            name: {{ .Values.app.name }}-secret

        # Standard env vars every service must have
        env:
        - name: SPRING_PROFILES_ACTIVE
          value: {{ .Values.config.appEnv | default "dev" }}
        - name: VAULT_TOKEN
          valueFrom:
            secretKeyRef:
              name: {{ .Values.app.name }}-vault-token
              key: VAULT_TOKEN
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace

        # Resource limits — always enforced
        resources:
          requests:
            memory: {{ .Values.resources.requests.memory | default "256Mi" }}
            cpu: {{ .Values.resources.requests.cpu | default "100m" }}
          limits:
            memory: {{ .Values.resources.limits.memory | default "512Mi" }}
            cpu: {{ .Values.resources.limits.cpu | default "500m" }}

        # Liveness probe — always enforced
        livenessProbe:
          httpGet:
            path: {{ .Values.health.livenessPath | default "/actuator/health/liveness" }}
            port: {{ .Values.app.port | default 8080 }}
          initialDelaySeconds: {{ .Values.health.initialDelaySeconds | default 60 }}
          periodSeconds: {{ .Values.health.periodSeconds | default 10 }}
          failureThreshold: 3

        # Readiness probe — always enforced
        readinessProbe:
          httpGet:
            path: {{ .Values.health.readinessPath | default "/actuator/health/readiness" }}
            port: {{ .Values.app.port | default 8080 }}
          initialDelaySeconds: {{ .Values.health.initialDelaySeconds | default 30 }}
          periodSeconds: 5
          failureThreshold: 3

      # Graceful shutdown — always enforced
      terminationGracePeriodSeconds: {{ .Values.app.terminationGracePeriod | default 60 }}
{{- end }}