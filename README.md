# Terraform task

*"Test project, to demonstrate work with GCP and Terraform"*

- [Introductory Instruction](#introductory-instruction)
- [Install Ingress-nginx and Prometheus](#install-ingress-nginx-and-prometheus)

## Introductory Instruction

This project will automate the deployment of a Kuberentes cluster - 1 controlplane and 1 worker node - in GCP.\
One of the features of the project is that talos linux will be used as the operating system. 

\
And so, below I will describe the main components, which will be implemented in GCP. \
As well as the result, which should be in the end.

---

1. Creating a custom image talos linux *(dir. custom_talos_image)*
    - storage bucket
    - compute image 
---
2. Creating and setting up a network *(dir. network)*
    - Network
    - Subnetwork
    - Firewall
    - External ip for controlplane and worker node
---
3. Creating and setting up the controlplane and worker node *(dir. instances)*
    - Compute instance controlplane
    - Controlplane instance group
    - Health check tcp instance group
    - Compute instance worker node
---
4. Creating and setting up LB *(dir. load_balancer)*
    - backend service
    - load balancer
    - proxy
    - forwarding rule
---
5. Running commands to create and customize configuration files for talos linux and kubernetes *(dir. config_creator)*
    - talos config
    - apply-config controlplane
    - apply-config worker node
    - set endpoint and node
    - apply bootstrap
    - generate kubeconfig
---

**It is necessary to follow the order of the terraform configurations above.** 

Result:

<br>
<br>
<br>

## Install Ingress-nginx and Prometheus

I suggest using helm to install ingress-nginx and prometheus.
I will do a basic installation using the repositories:
 - https://kubernetes.github.io/ingress-nginx
 - https://prometheus-community.github.io/helm-charts


 1. ```
        helm --kubeconfig ./talos_conf/kubeconfig upgrade \
            --install ingress-nginx ingress-nginx \
            --repo https://kubernetes.github.io/ingress-nginx \
            --namespace ingress-nginx \
            --create-namespace
    ```


Result:





2. ```
        helm --kubeconfig ./talos_conf/kubeconfig \
            repo add prometheus-community https://prometheus-community.github.io/helm-charts \
            && helm --kubeconfig ./talos_conf/kubeconfig \
            upgrade  --install monitor prometheus-community/kube-prometheus-stack \
            --namespace monitoring \
            --create-namespace

   ```


Result:



