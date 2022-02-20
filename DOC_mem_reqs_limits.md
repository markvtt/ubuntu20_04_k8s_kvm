

kubectl create namespace default-mem-example

kubectl config set-context --current --namespace=default-mem-example

cat<< EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: default-mem-demo-2
spec:
  containers:
  - name: default-mem-demo-2-ctr
    image: nginx
    resources:
      limits:
        memory: "1Gi"
EOF

k get po/default-mem-demo-2 -o yaml

k delete po/default-mem-demo-2

# create default limits
cat<<EOF | kubectl apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 512Mi
    defaultRequest:
      memory: 256Mi
    type: Container
EOF

cat<< EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: default-mem-demo-2
spec:
  containers:
  - name: default-mem-demo-2-ctr
    image: nginx
    resources:
      limits:
        memory: "1Gi"
EOF

# if you specify limit then request is the same
k get po/default-mem-demo-2 -o yaml

# if you don't have any resource attrs will use default
cat<< EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: default-mem-demo-2
spec:
  containers:
  - name: default-mem-demo-2-ctr
    image: nginx
EOF


kubectl delete namespace default-mem-example