.PHONY: up down init cluster-up install uninstall logs repos namespaces cluster-down clean provision

up: cluster-up init docker platform test prod tests monitoring-logging

down: cluster-down

cluster-down:
	sudo k3d cluster delete l3p

clean: logs
	
cluster-up:
	sudo k3d cluster create l3p \
	    -p 80:80@loadbalancer \
	    -p 443:443@loadbalancer \
	    -p 30000-32767:30000-32767@server[0] \
	    -v /etc/machine-id:/etc/machine-id:ro \
	    -v /var/log/journal:/var/log/journal:ro \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    --k3s-server-arg '--no-deploy=traefik' \
	    --agents 3

docker:
	sudo docker login
	sudo kubectl create secret generic docker-hub-creds --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json --type=kubernetes.io/dockerconfigjson -n test
	sudo kubectl create secret generic docker-hub-creds --from-file=.dockerconfigjson=/home/ubuntu/.docker/config.json --type=kubernetes.io/dockerconfigjson -n prod

init: logs namespaces 
platform: install-cicd install-ingress 
monitoring-logging: install-logging install-monitoring
logs:
	touch output.log
	rm -f output.log
	touch output.log

namespaces:
	sudo kubectl apply -f platform/namespaces/namespaces.yaml


install-cicd:
	sudo echo "cicd: install" | tee -a output.log
	sudo kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
	sudo kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml
	sudo kubectl patch svc tekton-dashboard -n tekton-pipelines --type='json' -p '[{"op":"replace", "path":"/spec/type", "value":"NodePort"}]'
	sudo kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml
	sudo kubectl create configmap config-artifact-pvc \
                         --from-literal=size=10Gi \
                         --from-literal=storageClassName=manual \
                         -o yaml -n tekton-pipelines \
                         --dry-run=client | sudo kubectl replace -f -
	sudo apt update
	sudo apt install -y gnupg
	sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA
	echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu eoan main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list
	sudo apt update && sudo apt install -y tektoncd-cli
delete-cicd:
	echo "cicd: delete" | tee -a output.log
	sudo kubectl delete -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
	sudo kubectl delete -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml

tests: front-end-test cart-test catalogue-test orders-test payment-test shipping-test users-test queue-master-test

test:
	sudo kubectl apply -f e2e-js-test/task.yaml -f e2e-js-test/tr.yaml -n test 
	sudo kubectl apply -f production.yaml -f ingress.yaml -n test
prod:
	sudo kubectl apply -f production.yaml -f ingress.yaml -n prod

front-end-test:
	sudo kubectl apply -f front-end/sa.yaml -f front-end/pl-resource.yaml -f front-end/task.yaml  -f front-end/dep-task.yaml -f front-end/front-end-test-t.yaml -f front-end/dep-pl.yaml -f front-end/dep-pr.yaml -n test

front-end-prod:
	sudo Kubectl apply -f front-end/sa.yaml -f front-end/pl-resource.yaml  -f front-end/dep-task.yaml -f front-end/dep-tr.yaml -n prod

cart-test:
	sudo sudo kubectl apply -f carts/sa.yaml -f carts/pl-resource.yaml -f carts/task.yaml  -f carts/dep-task.yaml -f carts/cart-test-t.yaml -f carts/dep-pl.yaml -f carts/dep-pr.yaml -n test

cart-prod:
	sudo Kubectl apply -f carts/sa.yaml -f carts/pl-resource.yaml -f carts/dep-task.yaml -f carts/dep-tr.yaml -n prod

catalogue-test:
	sudo kubectl apply -f catalogue/sa.yaml -f catalogue/pl-resource.yaml -f catalogue/task.yaml  -f catalogue/dep-task.yaml -f catalogue/catalogue-test-t.yaml -f catalogue/dep-pl.yaml -f catalogue/dep-pr.yaml -n test

catalogue-prod:
	 sudo Kubectl apply -f catalogue/sa.yaml -f catalogue/pl-resource.yaml -f catalogue/dep-task.yaml -f catalogue/dep-tr.yaml -n prod

orders-test:
	sudo kubectl apply -f orders/sa.yaml -f orders/pl-resource.yaml -f orders/task.yaml  -f orders/dep-task.yaml -f orders/orders-test-t.yaml -f orders/dep-pl.yaml -f orders/dep-pr.yaml -n test

orders-prod:
	sudo Kubectl apply -f orders/sa.yaml -f orders/pl-resource.yaml -f orders/dep-task.yaml -f orders/dep-tr.yaml -n prod

payment-test:
	sudo kubectl apply -f payment/sa.yaml -f payment/pl-resource.yaml -f payment/task.yaml  -f payment/dep-task.yaml -f payment/payment-test-t.yaml -f payment/dep-pl.yaml -f payment/dep-pr.yaml -n test

payment-prod:
	sudo Kubectl apply -f payment/sa.yaml -f payment/pl-resource.yaml -f payment/dep-task.yaml -f payment/dep-tr.yaml -n prod	

shipping-test:
	sudo kubectl apply -f shipping/sa.yaml -f shipping/pl-resource.yaml -f shipping/task.yaml  -f shipping/dep-task.yaml -f shipping/shipping-test-t.yaml -f shipping/dep-pl.yaml -f shipping/dep-pr.yaml -n test

shipping-prod:
	sudo Kubectl apply -f shipping/sa.yaml -f shipping/pl-resource.yaml -f shipping/dep-task.yaml -f shipping/dep-tr.yaml -n prod

users-test:
	sudo kubectl apply -f user/sa.yaml -f user/pl-resource.yaml -f user/task.yaml  -f user/dep-task.yaml -f user/users-test-t.yaml -f user/dep-pl.yaml -f user/dep-pr.yaml -n test

users-prod:
	sudo Kubectl apply -f user/sa.yaml -f user/pl-resource.yaml -f user/dep-task.yaml -f user/dep-tr.yaml -n prod

queue-master-test:
	sudo kubectl apply -f queue-master/sa.yaml -f queue-master/pl-resource.yaml -f queue-master/task.yaml  -f queue-master/dep-task.yaml -f queue-master/queue-master-test-t.yaml -f queue-master/dep-pl.yaml -f queue-master/dep-pr.yaml -n test

queue-master-prod:
	sudo Kubectl apply -f queue/sa.yaml -f queue-master/pl-resource.yaml -f queue-master/dep-task.yaml -f queue-master/dep-tr.yaml -n prod

install-ingress:
	sudo echo "Ingress: install" | tee -a output.log
	sudo kubectl apply -n ingress-nginx -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log
	sudo kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

delete-ingress:
	sudo echo "Ingress: delete" | tee -a output.log
	sudo kubectl delete -n ingress -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/cloud/deploy.yaml | tee -a output.log 2>/dev/null | true
	sudo kubectl apply -f ingress.yaml

install-monitoring:
	sudo sh pro-graf/pro-graf.sh 

install-logging:
	sudo sh elf/elf.sh
