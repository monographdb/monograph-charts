{{/*
Expand the name of the chart.
*/}}
{{- define "monograph-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "monograph-operator.fullname" -}}
{{- if .Values.fullnameOverride }}
    {{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
    {{- $name := default .Chart.Name .Values.nameOverride }}
    {{- if contains $name .Release.Name }}
        {{- .Release.Name | trunc 63 | trimSuffix "-" }}
    {{- else }}
        {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
    {{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "monograph-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "monograph-operator.commonLabels" -}}
{{ include "monograph-operator.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/created-by: {{ include "monograph-operator.name" . }}
app.kubernetes.io/part-of: {{ include "monograph-operator.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
helm.sh/chart: {{ include "monograph-operator.chart" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "monograph-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "monograph-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Control plane label
*/}}
{{- define "monograph-operator.controlPlaneLabels" -}}
control-plane: {{ include "monograph-operator.name" . }}-controller-manager
{{- end }}
