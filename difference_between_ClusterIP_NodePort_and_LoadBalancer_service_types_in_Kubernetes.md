## Difference between ClusterIP, NodePort and LoadBalancer service types in Kubernetes?

![image](https://github.com/gThiru/devops/assets/20988358/c7042787-49ea-4959-ab28-d94286e07ebc)

### ClusterIP
A ClusterIP service is the default Kubernetes service. It gives you a service inside your cluster that other apps inside your cluster can access. There is no external access.

**A ClusterIP exposes the following:**

``spec.clusterIp:spec.ports[\*].port``


You can only access this service while inside the cluster. It is accessible from its spec.clusterIp port. If a ``spec.ports[*].targetPort`` is set it will route from the port to the targetPort. The CLUSTER-IP you get when calling kubectl get services is the IP assigned to this service within the cluster internally.

The YAML for a ClusterIP service looks like this:

    apiVersion: v1
    kind: Service
    metadata:  
      name: my-internal-service
    spec:
      selector:    
        app: my-app
      type: ClusterIP
      ports:  
      - name: http
        port: 80
        targetPort: 80
        protocol: TCP

### When would you use this?
There are a few scenarios where you would use the Kubernetes proxy to access your services.

Debugging your services, or connecting to them directly from your laptop for some reason


Allowing internal traffic, displaying internal dashboards, etc.


Because this method requires you to run kubectl as an authenticated user, you should NOT use this to expose your service to the internet or use it for production services.


**ClusterIP: Services are reachable by pods/services in the Cluster**
If I make a service called myservice in the default namespace of type: ClusterIP then the following predictable static DNS address for the service will be created:

``myservice.default.svc.cluster.local`` (or just myservice.default, or by pods in the default namespace just "myservice" will work)

And that DNS name can only be resolved by pods and services inside the cluster.

### Nodeport:

A NodePort service is the most primitive way to get external traffic directly to your service. NodePort, as the name implies, opens a specific port on all the Nodes (the VMs), and any traffic that is sent to this port is forwarded to the service.

The YAML for a NodePort service looks like this:

    apiVersion: v1
    kind: Service
    metadata:  
      name: my-nodeport-service
    spec:
      selector:    
        app: my-app
      type: NodePort
      ports:  
      - name: http
        port: 80
        targetPort: 80
        nodePort: 30036
        protocol: TCP

    
**A NodePort exposes the following:**

``NodeIP:spec.ports[*].nodePort``


``spec.clusterIp:spec.ports[*].port``

If you access this service on a nodePort from the node's external IP, it will route the request to ``spec.clusterIp:spec.ports[*].port``, which will in turn route it to your ``spec.ports[*].targetPort``, if set. This service can also be accessed in the same way as ClusterIP.

Your NodeIPs are the external IP addresses of the nodes. You cannot access your service from ``spec.clusterIp:spec.ports[*].nodePort``.

Basically, a NodePort service has two differences from a normal “ClusterIP” service. First, the type is “NodePort.” There is also an additional port called the nodePort that specifies which port to open on the nodes. If you don’t specify this port, it will pick a random port. Most of the time you should let Kubernetes choose the port; as 
thockin says, there are many caveats to what ports are available for you to use.


**When would you use this?**

There are many downsides to this method:

You can only have one service per port

You can only use ports 30000–32767


If your Node/VM IP address change, you need to deal with that
For these reasons, I don’t recommend using this method in production to directly expose your service. If you are running a service that doesn’t have to be always available, or you are very cost sensitive, this method will work for you. A good example of such an application is a demo app or something temporary.


**NodePort: Services are reachable by clients on the same LAN/clients who can ping the K8s Host Nodes (and pods/services in the cluster) (Note for security your k8s host nodes should be on a private subnet, thus clients on the internet won't be able to reach this service)**

If I make a service called mynodeportservice in the mynamespace namespace of type: NodePort on a 3 Node Kubernetes Cluster. Then a Service of type: ClusterIP will be created and it'll be reachable by clients inside the cluster at the following predictable static DNS address:

``mynodeportservice.mynamespace.svc.cluster.local`` (or just mynodeportservice.mynamespace)

For each port that mynodeportservice listens on a nodeport in the range of 30000 - 32767 will be randomly chosen. So that External clients that are outside the cluster can hit that ClusterIP service that exists inside the cluster. Lets say that our 3 K8s host nodes have IPs 10.10.10.1, 10.10.10.2, 10.10.10.3, the Kubernetes service is listening on port 80, and the Nodeport picked at random was 31852.

A client that exists outside of the cluster could visit 10.10.10.1:31852, 10.10.10.2:31852, or 10.10.10.3:31852 (as NodePort is listened for by every Kubernetes Host Node) Kubeproxy will forward the request to mynodeportservice's port 80.


## LoadBalancer

A LoadBalancer service is the standard way to expose a service to the internet. On GKE, this will spin up a Network Load Balancer that will give you a single IP address that will forward all traffic to your service.


**A LoadBalancer exposes the following:**

``spec.loadBalancerIp:spec.ports[*].port``


``NodeIP:spec.ports[*].nodePort``


``spec.clusterIp:spec.ports[*].port``


You can access this service from your load balancer's IP address, which routes your request to a nodePort, which in turn routes the request to the clusterIP port. You can access this service as you would a NodePort or a ClusterIP service as well.

**When would you use this?**

If you want to directly expose a service, this is the default method. All traffic on the port you specify will be forwarded to the service. There is no filtering, no routing, etc. This means you can send almost any kind of traffic to it, like HTTP, TCP, UDP, Websockets, gRPC, or whatever.


The big downside is that each service you expose with a LoadBalancer will get its own IP address, and you have to pay for a LoadBalancer per exposed service, which can get expensive!


**LoadBalancer: Services are reachable by everyone connected to the internet\* (Common architecture is L4 LB is publicly accessible on the internet by putting it in a DMZ or giving it both a private and public IP and k8s host nodes are on a private subnet)
(Note: This is the only service type that doesn't work in 100% of Kubernetes implementations, like bare metal Kubernetes, it works when Kubernetes has cloud provider integrations.)**

If you make mylbservice, then a L4 LB VM will be spawned (a cluster IP service, and a NodePort Service will be implicitly spawned as well). This time our NodePort is 30222. the idea is that the L4 LB will have a public IP of 1.2.3.4 and it will load balance and forward traffic to the 3 K8s host nodes that have private IP addresses. (10.10.10.1:30222, 10.10.10.2:30222, 10.10.10.3:30222) and then Kube Proxy will forward it to the service of type ClusterIP that exists inside the cluster.

You also asked: Does the NodePort service type still use the ClusterIP? Yes*
Or is the NodeIP actually the IP found when you run kubectl get nodes? Also Yes*

Lets draw a parrallel between Fundamentals:
A container is inside a pod. a pod is inside a replicaset. a replicaset is inside a deployment.
Well similarly:
A ClusterIP Service is part of a NodePort Service. A NodePort Service is Part of a Load Balancer Service.

In that diagram you showed, the Client would be a pod inside the cluster.

![Screenshot 2024-03-26 at 13 59 23](https://github.com/gThiru/devops/assets/20988358/d1179b45-4f39-4c17-bac8-a674ffedc627)


### Ingress

Unlike all the above examples, Ingress is actually NOT a type of service. Instead, it sits in front of multiple services and act as a “smart router” or entrypoint into your cluster.

You can do a lot of different things with an Ingress, and there are many types of Ingress controllers that have different capabilities.

The default GKE ingress controller will spin up a HTTP(S) Load Balancer for you. This will let you do both path based and subdomain based routing to backend services. For example, you can send everything on foo.yourdomain.com to the foo service, and everything under the yourdomain.com/bar/ path to the bar service.

![image](https://github.com/gThiru/devops/assets/20988358/bd490667-917a-4c52-9ada-424368bae784)


The YAML for a Ingress object on GKE with a L7 HTTP Load Balancer might look like this:
    
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
      name: my-ingress
    spec:
      backend:
        serviceName: other
        servicePort: 8080
      rules:
      - host: foo.mydomain.com
        http:
          paths:
          - backend:
              serviceName: foo
              servicePort: 8080
      - host: mydomain.com
        http:
          paths:
          - path: /bar/*
            backend:
              serviceName: bar
              servicePort: 8080

**When would you use this?**


Ingress is probably the most powerful way to expose your services, but can also be the most complicated. There are many types of Ingress controllers, from the Google Cloud Load Balancer, Nginx, Contour, Istio, and more. There are also plugins for Ingress controllers, like the cert-manager, that can automatically provision SSL certificates for your services.

Ingress is the most useful if you want to expose multiple services under the same IP address, and these services all use the same L7 protocol (typically HTTP). You only pay for one load balancer if you are using the native GCP integration, and because Ingress is “smart” you can get a lot of features out of the box (like SSL, Auth, Routing, etc)

