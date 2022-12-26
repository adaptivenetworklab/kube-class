# Kubernetes Ingress

### Eksplorasi Fitur Ingress
1. Traefik
2. Nginx

### Traefik

1. Lakukan 


### Troubleshoot

#### CAUSE
There is a webhook that gets called whenever there is an ingress action. If the nginx ingress is no longer installed but the ingress webhook is still there, this will interfere with further ingress actions.

#### SOLUTION
Please remove the nginx ingress webhook via the following command:
 
```bash
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```

For more information, please check this Github issue: https://github.com/kubernetes/ingress-nginx/issues/5401

### Referensi
https://youtu.be/u948CURLDJA

https://youtu.be/izWCkcJAzBw
