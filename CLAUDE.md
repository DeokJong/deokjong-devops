# Repository Guidelines

## Values Ownership

- `charts/**/values.yaml` 파일은 템플릿 기본값 전용이다.
- 환경별 또는 실제 렌더링 값을 `charts/**/values.yaml`에 넣지 않는다.
- 실제 렌더링 값은 `clusters/{clusterName}/**/values.yaml` 아래에 둔다.
- 클러스터 전체 공통 값은 `clusters/{clusterName}/config.yaml`에 둔다.
- 클러스터·도메인·계정·리전·네임스페이스·애플리케이션 인스턴스마다 다른 값은 `charts/` 가 아니라 `clusters/{clusterName}/` 아래에 둔다.

## Cluster Chart Structure

- `charts/cluster` 는 재사용 가능한 루트 클러스터 차트다.
- 클러스터 루트 Application(예: `clusters/sandbox/appset.yaml`)이 `charts/cluster` 를 렌더링한다.
- `charts/cluster/templates/appset.yaml` 은 Argo CD `ApplicationSet` 을 생성한다.
- ApplicationSet 은 `{{ .Values.global.basePath }}/**/values.yaml` 에서 애플리케이션을 자동 검색한다.
- 검색된 각 클러스터 values 파일은 다음 애플리케이션 메타데이터를 제공한다:
  - `appName`
  - `chartPath`
  - `releaseName`
  - `namespace`
  - `syncWave`

## Render Flow

- `clusters/{clusterName}/config.yaml` 이 `charts/cluster` 에 전달된다.
- 생성된 ApplicationSet 은 다음을 사용해 각 앱을 렌더링한다:
  - `$values/{basePath}/config.yaml`
  - `$values/{path-to-app}/values.yaml`
- 자식 차트는 `.Values.global` 을 통해 공유 값을 읽을 수 있으나, 해당 값은 자식 차트의 기본값이 아니라 `clusters/{clusterName}/config.yaml` 에서 온다.

## Chart Authoring Rules

- 차트 기본값은 제네릭하게, 비워두거나 안전한 플레이스홀더로 유지한다.
- 클러스터 values에서 반드시 제공해야 하는 값에는 템플릿에서 `required` 체크를 사용한다.
- `charts/**/values.yaml` 에 실제 도메인, 호스팅 존 ID, AWS 리전, 클러스터 이름, 레포 URL, 앱 이름, 네임스페이스를 하드코딩하지 않는다.
- 차트 인터페이스를 변경할 때는 해당 차트를 렌더링하는 `clusters/{clusterName}/{path-to-app}/values.yaml` 도 함께 업데이트한다.
- 재사용 가능한 템플릿 로직만 필요한 경우 `charts/_library` 아래에 배치한다.
- 라이브러리 차트는 독립 Application으로 등록하지 않는다.

## Chart Schema Rules

- 모든 차트는 `values.schema.json` 을 반드시 포함해야 한다.
- 차트를 새로 만들 때 `values.schema.json` 을 함께 작성한다.
- `values.yaml` 의 인터페이스(키 추가·삭제·타입 변경)를 수정할 때는 `values.schema.json` 도 반드시 동기화한다.
- 스키마는 `$schema: https://json-schema.org/draft-07/schema#` 를 명시한다.
- `required` 템플릿 체크가 있는 필드는 스키마의 `required` 배열에도 포함한다.
- `additionalProperties: false` 를 최상위 및 중첩 객체에 적용해 오타를 조기에 차단한다.
- enum 제약이 있는 필드(예: `pullPolicy`, `difficulty`)는 스키마에 `enum` 으로 명시한다.
- `clusters/{clusterName}/config.yaml` 은 모든 차트에 공통으로 주입되므로, 스키마 최상위에 `global` 프로퍼티를 반드시 허용해야 한다. 누락 시 ArgoCD 렌더링 시 `additional properties 'global' not allowed` 오류가 발생한다.

## Gateway And HTTPRoute Convention

- Platform Gateway 리소스는 `charts/platform/wildcard-tls` 가 생성한다.
- Gateway 는 `gateway-system` 네임스페이스에 위치해야 한다.
- 표준 Gateway 이름은 `public-gateway` 와 `private-gateway` 다.
- 각 Gateway 는 포트 80(http)과 포트 443(https)을 노출한다.
- 서비스 차트는 raw HTTPRoute 템플릿을 직접 작성하는 대신 `charts/_library/http-route` 라이브러리 차트를 사용한다.
- 라우트 값에는 `gatewayType`: `public`, `private`, `all` 중 하나를 사용한다.
- HTTPRoute 백엔드 타겟은 `backendRefs` 로 표현한다.
- HTTP → HTTPS 리다이렉트는 `http` 리스너에 연결된 별도 HTTPRoute로 구현한다.
- TLS 종료는 Gateway에서 처리한다. 백엔드는 일반적으로 HTTP 서비스 포트(예: Argo CD server 포트 `80`)를 사용한다.

## ArgoCD Diff 방지 규칙

ArgoCD는 Kubernetes API server가 주입하는 default 값과 템플릿에 없는 필드를 diff로 감지한다. 아래 필드는 반드시 템플릿에 명시한다.

- HTTPRoute / TCPRoute `parentRefs` 에는 `group: gateway.networking.k8s.io` 와 `kind: Gateway` 를 명시한다.
- HTTPRoute / TCPRoute `backendRefs` 에는 `group: ""`, `kind: Service`, `weight: 1` 을 명시한다.
- StatefulSet `volumeClaimTemplates` 항목에는 `apiVersion: v1` 과 `kind: PersistentVolumeClaim` 을 명시한다.

## Bootstrap Caution

- `bootstrap` 은 Argo CD 자체를 설치한다.
- `bootstrap` 의 `appName` 을 변경할 때는 주의한다. ApplicationSet 이 기존 Application을 prune하면 finalizer를 통해 Argo CD 리소스가 삭제될 수 있다.
