# Day 1
   I created a github repo along with trello board
finish listing the backlogs for the first sprint
DoD: Creating cluster with namespaces

# Day 2 
  Push docker images of each microservices to dockerhub 

I faild today to finish the task ;(

# Day 3
I'll try to push the images again to dockerhub 
And try running the app
I succeeded and pushed  some of the images to docker hub after changeing the namespace to tekton-pipelines(tekton works only in this namespace appearntly) 
some of service's dockerfiles need to be multistaged to work and i'm having a problem with that :(

# Day 4 
 I'm going to try the docker images locally before i use them in tekton.. even tho i tried some and they don't work,for example the "user" it gave me "no reachable servers",and "orders" could not reach it vi browser with port.
But "front-end" is working fine(at least one service is working yaay)

EOD i had a problem with "cart's" dockerfile but thanks to fish he found the problem..we were using an old sourcecode and we did not pay attention to the tags of the realses..we suppose to use the latest..i tried some of the images and they were woking fine except "user" it show "no reachable servers",i had to skip it to work o the other ones.
still i have some services' dockerfiles to test but it's getting late duuude i can't stay up all night.. calm down i'll do them tomorrow

# Day 5 

Ooops late for writting today.. anyways.. i managed to check all dockerfile.. now i have to push them to dockerhub using tekton.
  well.. i managed to finish checking dockerfiles and i moved to k8s to build and push the images to dockerhub.. 
The problem i thought i had because of the namespace was not real,it's just because i probably missed to specify the namespace in every step from making the secret to the yaml files.
I had webhook error also because i cloned a project in my repo without deleting .git dirctory..

EOD i pushed all images except 2 with dbs "load-test and queue-master" eventhough they were wroking fine locally.(sooooooo mad)

# Day 6

I'll push the remainaing images. and deploy the app.
AAAAAAAAAAAAA (crying and screaming).. i wrote the dairy but i vi it by a relative path,and when i wanted to add it to git i (add .) local changes only waahhaaaa..

i finally pushed the images using tekton even though after the local test i had some issues with some yester and i sloved it by changing the images and my mistakes. like not writting the path in the param value in task.yaml
 
I took a look at the _deply_ dictory to healp me writing the yaml files and found out that logging used another service   _log-server_  so i wen to build the image for it and like any thing in life, it was not working and it was showing me a permissin error in ruby. i thought it was the base image because it was using a depracated tag "onbuild". But the error did not disapear. 
Since i picked the latest tag somethings has to change, so and env value _USER_ has to be used, but this did not solve the issue.. hmmmmm but one thing catched my eyes and looked suspaciouce.. 
it's _sudo_ in the _RUN_ command,,why would i use sudo if i'm the root broo!!! so i deleted along with it _-u fluent_ and booooom 
the build has finished successfully.. after hours of trying and not watching TekTok videos or instagram....the problem that held me back from entertainment was *sudo* ..waaaaaw
Aaan that's it, it's the EOD byeeee

# Day 7

Tried to deploy front-end and added an ingress using microservices-demo manifests i had some errors regarding the apiVersion since the last commit of these files were 3 years ago.

When running front-end _nginx_ ingress i get 503 error. i'm still working on it

# Day 8

After failing to deploy front-end i tried catalogue service and the k8s dashboard but i get the same respoe .., server refused to connect. i can't find the cause. i even cheecked the ingress in security groupes in terraform and pot 80 is open. and the cluster is the runnig the services and deployment when i list pods and svc's..i'm losing modivation .

# Day 9 
 Dear Dairy,,
   today and after days of suffering i finally solved the mystery.It's because of fish again. 
He's an incredible detective.
the service and the deployment could not connect because of the labels, key:value. i was focuing on the value and not the key, both of them should be matching not only the value.
I started to deploy the services to test them before i put them as tasks, i will continue tomorrow 

# Day 10
 &#x1F537; heyyy..I deployed front-end catalogue cart payment and shipping. but in catalogue and some of the services i had to give it a root access,error &#x1F53B; exit="listen tcp :80: bind: permission denied"&#x1F53B;  _NET_BIND_SERVICE was not working to give the nonroot user bind to port 80. The only sultotion i have till now is to make it _root_ &#x1F534; (bad, i know). 
But even the in the docketfile the user were given _cap_net_bind_service=+ep_ ,it is not working appearntly.

# Day 11
  Today i completed the rest of the deployment except payment it gives me the same error as yesterday.  User-db had a probelm in building dockerfile in -*Tekton*-, building and other steps times out after 1 hour of waiting to the prev step to finish, turns out there's a _--shutdown_ flag to stop the process(not sure why would weaveworks want to shut down, so i'm not sure if it will affect the functionality ) but after removing the flag it did not take more than 3 mins to finish the whole process.

# Day 12
I fixed the payment service by redoing the dockerfile.User also was not working today and i had to run it as root _runAsUser= 0_.Now I'm trying to deploy monitoring for the whole app.

# Day 13
 I'm about to try deploying the microservices with tekton. 
EOD finally succeeded, i deployed catalogue using tekton.i have tried several methods and finally one of them worked,but i was getting the "path to yaml file not found" and the problem was because i was putting the args for the params in the same line. 

I had to put each flag and command in a separate line.I had to use role and roleBinding to run the pipeline and pipelineRun.

# Day 14
&#x1F537; I deployed each microservice in tekton (finally). but i don't get it what tis the point of the pipeline if it needs to run each task before..it's already running why would i run it again in a pipeline broo.
Anyways i did it... aaaand an errot that drove me crazy when i run the pipeline and pipelineRun i fied it by putting the name of the resource and any name that is resorce related the _same name_. ot solved the confusion. 
&#x1F537; I added ingress, it works with front end, but not the other services, it gives me a _js_ and some sort of page error.. too sleepy to check it out of try to fix it zzZZ

# Day 15 
   I run e2e tests and they failed locally when i try it with front-end services name. 
I had to change it to the ip, it worked but have some fails like Cart, login and Checkout have the most fails.

 I changed the password to "eve" instead of -duis-(because it's the wrong passcode) to fix the login test.Added line *10* in checkout_test.js and _});_ in line *25*

# Day 16
  Today i tried to make tests in tekton, i made a task with script to _npm init & install_ but i got "mongodb module not found_ this error comes when i run _test_helper.js_ in _runner.js_. 

But the module was not installed when i did make _npm_ or _install_, so i added mongo db to the install list, since i downloaded the latest verion the _test_helper.js_ was written in an old format so i did changed the object from _db_ to _client_ and added line *17*. 

Failing in cart caused by mongodb also wrong _url_, I changed it to carts-db serveice name.
