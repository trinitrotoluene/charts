{{- define "prowlarr.workload" -}}
workload:
  prowlarr:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      hostNetwork: {{ .Values.prowlarrNetwork.hostNetwork }}
      containers:
        prowlarr:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.prowlarrRunAs.user }}
            runAsGroup: {{ .Values.prowlarrRunAs.group }}
          env:
            PROWLARR__PORT: {{ .Values.prowlarrNetwork.webPort }}
            PROWLARR__INSTANCE_NAME: {{ .Values.prowlarrConfig.instanceName }}
          {{ with .Values.prowlarrConfig.additionalEnvs }}
          envList:
            {{ range $env := . }}
            - name: {{ $env.name }}
              value: {{ $env.value }}
            {{ end }}
          {{ end }}
          probes:
            liveness:
              enabled: true
              type: http
              port: "{{ .Values.prowlarrNetwork.webPort }}"
              path: /ping
            readiness:
              enabled: true
              type: http
              port: "{{ .Values.prowlarrNetwork.webPort }}"
              path: /ping
            startup:
              enabled: true
              type: http
              port: "{{ .Values.prowlarrNetwork.webPort }}"
              path: /ping
{{- end -}}
