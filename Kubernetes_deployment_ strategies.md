## Types of deployment strategies
1. Recreate
2. RollingUpdate
3. BlueGreen
4. Canary

### Recreate
Recreate strategies is used to delete the pods and recreate it with the newer versions.  

This strategy used when we are not bother about the previous version of deployment and mostly prefered in development envirinments. 

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: spring-boot-example
spec:
  replicas: 3
  strategy:
    type: Recreate ## Recreate strategy 
  template:
    metadata:
      labels:
        app: spring-boot-example
    spec:
      containers:
        - name: spring-boot-example
          image: 'gcr.io/fleet-resolver-237016/spring-boot-example:v1'
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: spring-boot-example
  labels:
    name: spring-boot-example
spec:
  ports:
    - port: 8080
      targetPort: 8080
      protocol: TCP
  selector:
    app: spring-boot-example
  type: LoadBalancer
```

### RollingUpdate
Rolling update is the default update strategy in kubernetes, which will create a pod first and destroy the older one 

```yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: spring-boot-example
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    metadata:
      labels:
        app: spring-boot-example
    spec:
      containers:
        - name: spring-boot-example
          image: 'gcr.io/fleet-resolver-237016/spring-boot-example:v1'
          ports:
            - containerPort: 8080
          readinessProbe: # To check the health of new pod before destroy the older one
            httpGet:
              path: /lazy # Health check path of application
              port: 8080 # Health check port of application
            initialDelaySeconds: 5 # The delay time when you want to initiate the probe after a pod up and running 
            periodSeconds: 5 # Probe timeout period, after specified number of seconds the probe will result a success or failure bease on the application response
```

### BlueGreen 
This deployment implemented by considering existing implementation is a Blue deployment and new deploymnet is a Green deployment.  
So when X version is 

