# Создание кластера
Перед созданием кластера должны быть определены порты для каждого проекта. В kind-local-config.yaml уже определены порты для to-dos и inner-circle.

Создание кластера
```bash
kind create cluster --name local-envs --config kind-local-config.yaml --kubeconfig ./.pelican-cluster-kubeconfig
```
# Деплой Pelican
После создания кластера можно деплоить Pelican
```bash
helmfile cache cleanup && helmfile --environment pelican --namespace pelican -f deploy/helmfile.yaml apply
```

# Деплой ToDos и Inner Circle

## Деплой ToDos
Сначала нужно склонировать ToDos https://github.com/TourmalineCore/to-dos-local-env

Далее надо поменять конфиг и переименовать deploy/environments/local в deploy/environments/to-dos:

deploy/values.yaml.gotmpl
```bash
ingress:
  ingressClassName: "to-dos-ingress-nginx"
  hostname: "{{ .Values.hostname }}"
  annotations:
    # to do not redirect from http to https
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
  tls: false

service:
  ports:
    http: {{ .Values.externalPort }}
```

deploy/values-ingress-nginx.yaml.gotmpl
```bash
# here you can find the readme of the config of the used version of nginx-ingress chart https://github.com/kubernetes/ingress-nginx/blob/helm-chart-4.10.1/charts/ingress-nginx/README.md
# here you can find the default values.yaml that we partially override in this file https://github.com/kubernetes/ingress-nginx/blob/helm-chart-4.10.1/charts/ingress-nginx/values.yaml

controller:
  ingressClass: to-dos-ingress-nginx
  ingressClassResource:
    name: to-dos-ingress-nginx
    controllerValue: "k8s.io/to-dos-ingress-nginx"

  service:
    type: NodePort
    ports:
      http: "{{ .Values.externalPort }}"
    nodePorts:
      http: "{{ .Values.internalPort }}"
      https: 
  # not needed in this setup
  admissionWebhooks:
    enabled: false
```

deploy/helmfile.yaml
```bash
repositories:
  - name: bitnami
    # url: https://charts.bitnami.com/bitnami
    # this mirro is used to avoid bocking from certain geographies
    # you can switch to the default one by uncommeniting the upper url and removing the mirror one
    url: https://mirror.yandex.ru/helm/charts.bitnami.com
  - name: ingress-nginx
    url: https://kubernetes.github.io/ingress-nginx

environments:
  to-dos:
    values:
      - environments/{{ .Environment.Name }}/values.yaml.gotmpl

releases:
  - name: to-dos-ingress-nginx
    labels:
      app: to-dos-ingress-nginx
    wait: true
    chart: ingress-nginx/ingress-nginx
    version: 4.12.1
    values:
      - values-ingress-nginx.yaml.gotmpl

  - name: to-dos-api
    labels:
      app: to-dos-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - to-dos-ingress-nginx
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/to-dos-api.git@/ci/values.yaml?ref={{ env "TO_DOS_API_BRANCH" | default "master" }}
      - values.yaml.gotmpl

  - name: to-dos-ui
    labels:
      app: to-dos-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - to-dos-ingress-nginx
      - to-dos-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/to-dos-ui.git@/ci/values.yaml?ref={{ env "TO_DOS_UI_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-to-dos-ui.yaml.gotmpl
```

Далее нужно скопировать kubeconfig из .pelican-cluster-kubeconfig проекта Pelican в .to-dos-cluster-kubeconfig проекта ToDos

После копирования kubeconfig`a деплоим ToDos
```bash
helmfile cache cleanup && helmfile --environment to-dos --namespace to-dos -f deploy/helmfile.yaml apply
```

## Деплой Inner Circle
Сначала нужно склонировать Inner Circle https://github.com/TourmalineCore/inner-circle-local-env

Далее надо поменять конфиг и переименовать deploy/environments/local в deploy/environments/inner-circle:

deploy/values.yaml.gotmpl
```bash
ingress:
  ingressClassName: "inner-circle-ingress-nginx"
  hostname: "{{ .Values.hostname }}"
  annotations:
    # to do not redirect from http to https
    nginx.ingress.kubernetes.io/force-ssl-redirect: "false"
  tls: false

service:
  ports:
    http: 30090
```

deploy/values-ingress-nginx.yaml.gotmpl
```bash
# here you can find the readme of the config of the used version of nginx-ingress chart https://github.com/kubernetes/ingress-nginx/blob/helm-chart-4.10.1/charts/ingress-nginx/README.md
# here you can find the default values.yaml that we partially override in this file https://github.com/kubernetes/ingress-nginx/blob/helm-chart-4.10.1/charts/ingress-nginx/values.yaml

controller:
  ingressClass: inner-circle-ingress-nginx
  ingressClassResource:
    name: inner-circle-ingress-nginx
    controllerValue: "k8s.io/inner-circle-ingress-nginx"
  service:
    type: NodePort
    ports:
      # -- Port the external HTTP listener is published with.
      http: "30090"
    nodePorts:
      http: "30090"
      https: 
  # not needed in this setup
  admissionWebhooks:
    enabled: false	
```

deploy/helmfile.yaml
```bash
repositories:
  - name: bitnami
    url: https://mirror.yandex.ru/helm/charts.bitnami.com
  - name: ingress-nginx
    url: https://kubernetes.github.io/ingress-nginx

environments:
  inner-circle:
    values:
      - environments/{{ .Environment.Name }}/values.yaml.gotmpl

helmDefaults:
  timeout: 600
  
releases:
  - name: inner-circle-ingress-nginx
    labels:
      app: inner-circle-ingress-nginx
    wait: true
    chart: ingress-nginx/ingress-nginx
    version: 4.10.1
    values:
      - values-ingress-nginx.yaml.gotmpl

  - name: postgresql
    namespace: default
    labels:
      app: postgresql
    wait: true
    chart: bitnami/postgresql
    version: 12.2.7
    values:
      - values-postgre.yaml.gotmpl

  - name: inner-circle-auth-api
    labels:
      app: inner-circle-auth-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-accounts-api
      - inner-circle-email-sender
      - postgresql
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/auth-api.git@/Api/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-auth-api.yaml.gotmpl

  - name: inner-circle-accounts-api
    labels:
      app: inner-circle-accounts-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-employees-api
      - postgresql
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/accounts-api.git@/Api/ci/values-local-env.yaml?ref={{ env "ACCOUNTS_API_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-accounts-api.yaml.gotmpl

  - name: inner-circle-documents-api
    labels:
      app: inner-circle-documents-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-employees-api
      - inner-circle-email-sender
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-documents-api.git@/Api/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-documents-api.yaml.gotmpl

  - name: inner-circle-compensations-api
    labels:
      app: inner-circle-compensations-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-employees-api
      - postgresql
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-compensations-api.git@/Api/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-compensations-api.yaml.gotmpl

  - name: inner-circle-employees-api
    labels:
      app: inner-circle-employees-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - postgresql
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-employees-api.git@/Api/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-employees-api.yaml.gotmpl
  
  - name: inner-circle-books-api
    labels:
      app: inner-circle-books-api
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - postgresql
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-books-api.git@/Api/ci/values-local-env.yaml?ref={{ env "INNER_CIRCLE_BOOKS_API_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-books-api.yaml.gotmpl

  - name: inner-circle-email-sender
    labels:
      app: inner-circle-email-sender
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-email-sender.git@/Api/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-email-sender.yaml.gotmpl

  - name: inner-circle-auth-ui
    labels:
      app: inner-circle-auth-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-auth-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/auth-ui.git@/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-auth-ui.yaml.gotmpl

  - name: inner-circle-accounts-ui
    labels:
      app: inner-circle-accounts-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-accounts-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/accounts-ui.git@/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-accounts-ui.yaml.gotmpl

  - name: inner-circle-documents-ui
    labels:
      app: inner-circle-documents-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-documents-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-documents-ui.git@/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-documents-ui.yaml.gotmpl

  - name: inner-circle-compensations-ui
    labels:
      app: inner-circle-compensations-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-compensations-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-compensations-ui.git@/ci/values-local-env.yaml?ref={{ env "INNER_CIRCLE_COMPENSATION_UI_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-compensations-ui.yaml.gotmpl

  - name: inner-circle-ui
    labels:
      app: inner-circle-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
      - inner-circle-employees-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-ui.git@/ci/values-local-env.yaml?ref=master
      - values.yaml.gotmpl
      - values-ui.yaml.gotmpl

  - name: inner-circle-layout-ui
    labels:
      app: inner-circle-layout-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-layout-ui.git@/ci/values-local-env.yaml?ref={{ env "INNER_CIRCLE_LAYOUT_UI_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-layout-ui.yaml.gotmpl

  - name: inner-circle-books-ui
    labels:
      app: inner-circle-books-ui
    wait: true
    chart: bitnami/nginx
    # after 15.3.5 our docker file or setup can no longer start, need to investigate what is wrong for the newer versions
    version: 15.3.5
    # it won't work anyway until ingress controller is created
    # thus we wait for it to be ready first
    needs: 
      - inner-circle-ingress-nginx
    # - inner-circle-books-api
    values:
      # https://helmfile.readthedocs.io/en/latest/#loading-remote-environment-values-files
      - git::https://github.com/TourmalineCore/inner-circle-books-ui.git@/ci/values-local-env.yaml?ref={{ env "INNER_CIRCLE_BOOKS_UI_BRANCH" | default "master" }}
      - values.yaml.gotmpl
      - values-books-ui.yaml.gotmpl
```

Далее нужно скопировать kubeconfig из .pelican-cluster-kubeconfig проекта Pelican в .inner-circle-cluster-kubeconfig проекта Inner Circle

После копирования kubeconfig`a деплоим Inner Circle
```bash
helmfile cache cleanup && helmfile --environment inner-circle --namespace inner-circle -f deploy/helmfile.yaml apply
```
