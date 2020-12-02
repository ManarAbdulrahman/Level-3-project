# Level-3-project

SDA DevOps Capstone project 

# Capstone Project

  This project is a weaveworks's demo for microservices. I used it to build and deploy these services in k3d and multiable tools along side k8s, such as Tekton,FluentD (kibana), Prometheus and Grafana.

# SockShop

   To run the whole project with Monitoring and Loging Dashboards   

`make up`

You will be asked to enter the DockerHub creds for makeing a secret to push the images to dockerhub repo.
 After this step, the services will be created and deployed to test, then to production phases.


# To deploy all services and their tests

`make tests`

# Deploying an Individual service

Use make to run the services, just write the name followed but -test or -prod to deployint it production

Ex.
`make cart-test`

*users* & *cart* instead of user and carts

# Monitoring 
You can access Grafana And Kibana by wrting the port number after the IP  


