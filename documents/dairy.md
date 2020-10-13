# Day 1
   I created a github repo along with trello board
finish listing the backlogs for the first sprint (4 days)
DoD: Creating cluster with namespaces

# Day 2 
  Puch docker images of each microservices to dockerhub 

I faild to day to finish the task ;(

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

