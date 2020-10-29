pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: pro-grafa
    image: bryandollery/terraform-packer-aws-alpine 
    command: 
    - bash
    tty: true
"""
    }
  }
  stages {
      stage("build") {
          steps {
              container('pro-grafa') {
                  sh '. pro-graf.sh'
              }
          }
      }
  }

}

