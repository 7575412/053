# JupyterLite Data Project

브라우저에서 실행되는 JupyterLite 기반 데이터 프로젝트입니다.

## 📁 프로젝트 구조

```
dist/
├── index.html              # 루트 진입점
├── config-utils.js         # JupyterLite 설정 유틸리티
├── bootstrap.js            # 앱 부트스트랩 (확장 플러그인 로드)
├── service-worker.js       # 서비스 워커 (캐싱 처리)
├── jupyter-lite.json       # JupyterLite 전역 설정
├── overrides.json          # 테마 등 설정 오버라이드
├── lab/                    # JupyterLab 앱
├── build/                  # 빌드 결과물 (JS 번들 등)
├── extensions/             # Federated 확장 플러그인
├── pypi/                   # Python 패키지 (Pyodide용)
├── static/                 # 정적 파일
└── files/                  # 사용자 파일
```

## 🚀 실행 방법

로컬 서버를 실행한 후 브라우저에서 접속합니다.

```bash
# Python 사용
python -m http.server 8000

# 브라우저에서 접속
http://localhost:8000
```

## 🔧 주요 설정

- **기본 커널**: Python (Pyodide)
- **테마**: JupyterLab Light
- **앱 버전**: 0.7.6

## 📦 포함된 확장 플러그인

| 플러그인 | 설명 |
|---------|------|
| `@jupyter-notebook/lab-extension` | Jupyter Notebook 지원 |
| `@jupyter-widgets/jupyterlab-manager` | ipywidgets 지원 |
| `jupyterlab-plotly` | Plotly 시각화 |
| `jupyterlab_pygments` | 코드 하이라이팅 |

## 🐛 버그 수정 이력

### v1.0.1
- `config-utils.js` — `dedupFederatedExtensions` 함수 버그 2개 수정
  - `Object.keys()` 오용으로 `federated_extensions` 접근 실패 수정
  - 중복 제거된 extensions 결과를 config에 저장하지 않던 문제 수정
