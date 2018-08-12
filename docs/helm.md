# [helm](https://github.com/helm/helm/releases)
- list
```
helm ls
```
- init
```
helm init --service-account tiller
```
- install
```
helm install ui --name ui-1
```
- update
```
helm upgrade ui-3 ui
```
- update dependencies:
```
helm dep update
```
- search remote rep:
```
helm search mongo
```
- delete:
```
helm delete reddit-test
```
