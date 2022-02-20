
# image from https://github.com/jmalloc/echo-server

cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echo-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo-server
  template:
    metadata:
      labels:
        app: echo-server
    spec:
      containers:
        - name: echo-server
          image: jmalloc/echo-server
          ports:
            - name: http-port
              containerPort: 8080
EOF

cat <<EOF | kubectl apply -f -
kind: Service 
apiVersion: v1 
metadata:
  name: echo-service 
spec:
  # Expose the service on a static port on each node
  # so that we can access the service from outside the cluster 
  type: NodePort

  # When the node receives a request on the static port (30163)
  # "select pods with the label 'app' set to 'echo-hostname'"
  # and forward the request to one of them
  selector:
    app: echo-server 

  ports:
    # Three types of ports for a service
    # nodePort - a static port assigned on each the node
    # port - port exposed internally in the cluster
    # targetPort - the container port to send requests to
    - nodePort: 30163
      port: 8080 
      targetPort: 8080
EOF

kubectl scale deployment/echo-deployment --replicas=3

curl --header "X-Send-Server-Hostname: true" http://k8sworker3:30163



kubectl delete deployment/echo-deployment
kubectl delete svc/echo-service


