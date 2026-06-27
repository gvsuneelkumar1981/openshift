platform-charts/
├── README.md
├── org-base-chart/              ← library chart (architect owns)
│   ├── Chart.yaml
│   └── templates/
│       ├── _helpers.tpl
│       ├── _deployment.tpl
│       ├── _service.tpl
│       ├── _route.tpl
│       ├── _configmap.tpl
│       ├── _externalsecret.tpl  ← ESO skeleton (reference only)
│       ├── _secretstore.tpl     ← ESO skeleton (reference only)
│       ├── _vault.tpl           ← Vault skeleton (reference only)
│       └── _hpa.tpl             ← bonus: auto scaling
│
└── order-service/               ← team chart (team owns)
├── Chart.yaml               ← depends on org-base-chart
├── values.yaml
├── values-dev.yaml
├── values-uat.yaml
├── values-prod.yaml
└── templates/
├── deployment.yaml
├── service.yaml
├── route.yaml
├── configmap.yaml
└── externalsecret.yamlCreate Structurebash# Create full structure