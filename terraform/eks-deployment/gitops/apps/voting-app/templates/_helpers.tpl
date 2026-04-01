{{/*App fullname*/}}
{{- define "votingApp.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*Default labels block*/}}
{{- define "votingApp.labels" -}}
name: {{ include "votingApp.fullname" . }}
managedBy: {{ .Release.Service }}
chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}

{{/*Define result image*/}}
{{- define "votingApp.resultImage" -}}
{{- with .Values.result.image -}}
{{- $registry := .registry | default "docker.io" -}}
{{- printf "%s/%s:%s" $registry .repository (.tag | default "latest") -}}
{{- end -}}
{{- end -}}

{{/*Define vote image*/}}
{{- define "votingApp.voteImage" -}}
{{- with .Values.vote.image -}}
{{- $registry := .registry | default "docker.io" -}}
{{- printf "%s/%s:%s" $registry .repository (.tag | default "latest") -}}
{{- end -}}
{{- end -}}

{{/*Define worker image*/}}
{{- define "votingApp.workerImage" -}}
{{- with .Values.worker.image -}}
{{- $registry := .registry | default "docker.io" -}}
{{- printf "%s/%s:%s" $registry .repository (.tag | default "latest") -}}
{{- end -}}
{{- end -}}