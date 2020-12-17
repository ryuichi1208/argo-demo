package main

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
