{{- define "bazarr.workload" -}}
workload:
  bazarr:
    enabled: true
    primary: true
    type: Deployment
    podSpec:
      hostNetwork: {{ .Values.bazarrNetwork.hostNetwork }}
      containers:
        bazarr:
          enabled: true
          primary: true
          imageSelector: image
          securityContext:
            runAsUser: {{ .Values.bazarrRunAs.user }}
            runAsGroup: {{ .Values.bazarrRunAs.group }}
          command:
            - /entrypoint.sh
          args:
            - --port
            - {{ .Values.bazarrNetwork.webPort | quote }}
          {{ with .Values.bazarrConfig.additionalEnvs }}
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
              port: "{{ .Values.bazarrNetwork.webPort }}"
              path: /api/swagger.json
            readiness:
              enabled: true
              type: http
              port: "{{ .Values.bazarrNetwork.webPort }}"
              path: /api/swagger.json
            startup:
              enabled: true
              type: http
              port: "{{ .Values.bazarrNetwork.webPort }}"
              path: /api/swagger.json
{{- end -}}
