# EKS Terraform Repo

# What is Created after running the repo code

* EKS Control Plane managed by AWS.
* EKS EC-2 Worker-Nodes managed by Gaming Team.
* EKS API-Server-EndPoints, CA Cert and Roles, ARN's for Cluster and Role.
* AWS EC2, Security Groups, VPC, Roles, Launch-Configuration and Auto-Scaling0-Group.
* Output variable kubeconfig in module whEKS.
* Output variable config-map-aws-auth in module whNodesEKS.

# How to Provision EKS Cluster

These are below things you need to configure to make the EKS-Cluster Up and Running

1. [Provision heptio-authenticator]()
2. [Provision aws-client]()
3. [Provision kubectl]()
4. [Provision configmap.yaml]()
5. [Provision Dashboard (Optional. Only for Cluster-Admins)]()

### 1. Provision heptio-authenticator

Heptio-Authenticator will work as abstraction layer between Kubernetes RBAC and Amazon IAM to autenticate EKS.

Download and install the heptio-authenticator-aws binary as per environment for local machine. Heptio-authenticator binary will be available for below OS's.

* [Linux](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws)
* [Mac](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/darwin/amd64/heptio-authenticator-aws)
* [Windows](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/windows/amd64/heptio-authenticator-aws.exe)

[Heptio-Authenticator-EKS-Documentation](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html)

### 2. Provision aws-client

Amazon EKS requires at least version 1.15.32 of the AWS CLI. 

To install or upgrade the AWS CLI, see [Installing the AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) in the AWS Command Line Interface User Guide.

**Note**

Your system's Python version must be Python 3, or Python 2.7.9 or greater.

### 3. Provision kubectl

Download and install kubectl for your operating system. Amazon EKS vends kubectl binaries that you can use. It will be available for below OS's.

* [Linux](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/kubectl)
* [MacOS](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/darwin/amd64/kubectl)
* [Windows](https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/windows/amd64/kubectl.exe)

[kubectl-EKS-Documentation](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html)

```
[slamba ◯  Star-Lord  19.EKS ] ☘   kubectl version
Client Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.1", GitCommit:"d4ab4", GitTreeState:"clean",......} 
Server Version: version.Info{Major:"1", Minor:"10", GitVersion:"v1.10.3", GitCommit:"2bba01", GitTreeState:"clean",.....}
```

*Get the output of variable kubeconfig from terraform module whEKS.*

```
[slamba ◯  Star-Lord  19.EKS ] ☘  terraform output -module=whEKS kubeconfig > config
[slamba ◯  Star-Lord  19.EKS ] ☘  cp config ~/.kube/config
```

```
[slamba ◯  Star-Lord  19.EKS ] ☘  kubectl cluster-info
Kubernetes master is running at https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.yl4.us-east-1.eks.amazonaws.com

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

```
[slamba ◯  Star-Lord  19.EKS ] ☘  kubectl get nodes
NAME                         STATUS    ROLES     AGE       VERSION
ip-10-0-3-150.ec2.internal   Ready     <none>    36d       v1.10.3
ip-10-0-5-77.ec2.internal    Ready     <none>    36d       v1.10.3
```

```
[slamba ◯  Star-Lord  19.EKS ] ☘  terraform output -module=whEKS  kubeconfig

apiVersion: v1
clusters:
- cluster:
    server: https://XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.yl4.us-east-1.eks.amazonaws.com
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tL
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: heptio-authenticator-aws
      args:
        - "token"
        - "-i"
        - "PoC-EKS-Cluster-01"

```


### 4. Provision configmap.yaml

**Step-1 Find out the outputs of terraform module whNodesEKS**

Output will look like

```
[slamba ◯  Star-Lord  19.EKS ] ☘   terraform output -module=whNodesEKS config-map-aws-auth

apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: arn:aws:iam::12345678901:role/EKS-Node-Role
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
```

**Step-2 Deploy the config-map**

Pre-requisite : Please make sure kubectl is already configured before running this step.

```
[slamba ◯  Star-Lord  19.EKS ] ☘  terraform output -module=whNodesEKS config-map-aws-auth > configmap.yaml
[slamba ◯  Star-Lord  19.EKS ] ☘  kubectl apply -f configmap.yaml --dry-run
[slamba ◯  Star-Lord  19.EKS ] ☘  kubectl apply -f configmap.yaml
```

**Step-3 Verify if all is ok**

We should check whether all nodes are up and in Ready state as shown below.

```
[slamba ◯  Star-Lord  .kube ] ☘   kubectl get nodes --watch
NAME                         STATUS    ROLES     AGE       VERSION
ip-10-0-3-150.ec2.internal   Ready     <none>    36d       v1.10.3
ip-10-0-5-77.ec2.internal    Ready     <none>    36d       v1.10.3
[slamba ◯  Star-Lord  .kube ] ☘
```

Useful links
* [How to deploy configmap](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html)

### 5. Provisions Dashboard (Optional. Only for Cluster-Admins)

Deploying Dashboard is Optional. DevOps can consider other options as well for monitoring or GUI.

[EKS-Dashboard](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html)

Follow the instructions as above and install the Dashboard.