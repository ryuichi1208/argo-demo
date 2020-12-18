package main

workload_resources = [
  "ReplicaSet",
  "Deployment",
  "DaemonSet",
  "StatefulSet",
  "Job",
]

# deprecated な deployment のバージョンリスト
deprecated_deployment_version = [
  "extensions/v1beta1",
  "apps/v1beta1",
  "apps/v1beta2"
]

# 最新の API Version が使われているかのチェック
warn[msg] {
  input.kind == "Deployment"
  input.apiVersion == deprecated_deployment_version[i]
  msg = "最新の APIVersion apps/v1 を指定してください"
}

# privileged が使われているかのチェック
deny[msg] {
  input.kind == "Deployment"
  input.spec.template.spec.containers[_].securityContext.privileged == true
  msg = "privileged はセキュリティ上の理由で許可されていません"
}

deny[msg] {
  input.kind == workload_resources[_]
  not (input.spec.selector.matchLabels.app == input.spec.template.metadata.labels.app)
  msg = sprintf("Pod Template 及び Selector には app ラベルを付与してください（spec.template.metadata.labels.app、spec.selector.matchLabels.app）: [Resource=%s, Name=%s, Selector=%v, Labels=%v]", [input.kind, input.metadata.name, input.spec.selector.matchLabels, input.spec.template.metadata.labels])
}
