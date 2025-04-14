### Для начала обновления cms ввести
kubectl set image deployment/pelican-cms-nginx nginx=ghcr.io/tourmalinecore/pelican-cms:<tag> -n local
### Пример:
kubectl set image deployment/pelican-cms-nginx nginx=ghcr.io/tourmalinecore/pelican-cms:sha-ee3336d2d3ba7c0acd83e560a5f98891a3cd2440 -n local

### Для отслеживания обновления cms ввести
kubectl rollout status deployment/pelican-cms-nginx -n local

### Для начала обновления ui ввести
kubectl set image deployment/pelican-nginx nginx=ghcr.io/tourmalinecore/pelican-ui:<tag> -n local
### Пример:
kubectl set image deployment/pelican-nginx nginx=ghcr.io/tourmalinecore/pelican-ui:sha-16e9a126017d487c6d6690a462287b2db13ab68e -n local

### Для отслеживания обновления ui ввести
kubectl rollout status deployment/pelican-nginx -n local
