# k8s
[1]: https://github.com/kelseyhightower/kubernetes-the-hard-way

[kubernetes-the-hard-way][1]

`wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64`
- List the firewall rules in the kubernetes-the-hard-way VPC network:
```
gcloud compute firewall-rules list --filter="network:kubernetes-the-hard-way"
```
- Create the kubernetes-the-hard-way custom VPC network:
```
gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom
```
- Verify the kubernetes-the-hard-way static IP address was created in your default compute region:
```
gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"
```
