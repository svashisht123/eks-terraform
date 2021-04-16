#Problem Statement:

Build an API that will use a string as input and does a find and replace for certain
words and outputs the result. 

For example: replace Google for Google©.
Example input: “We really like the new security features of Google Cloud”.
Expected output: “We really like the new security features of Google Cloud©”.

The words that need to be replaced are provided below the description of this
assignment.

List of word that need to be replaced:
 Oracle -&gt; Oracle©
 Google -&gt; Google©
 Microsoft -&gt; Microsoft©
 Amazon -&gt; Amazon©
 Deloitte -&gt; Deloitte©


Solution :

URL to access the function :

http://694161c0-dev-demoapicluste-50db-1234729939.eu-west-1.elb.amazonaws.com/

The APIs have been built using Flask and deployed using Elastic Kubernetes Service. Python has been used here. Terraform is used to provision the resources as IaC. URL shared above is the ingress URL for EKS ALB. 
Following resources have been created:

> VPC : basic network setup, including subnets and Nat gateway
> EKS : Deployed on v1.18 , EKS IAM worker node and cluster role created
> Pipeline: Code build created to push the docker image to ECR. For this, we have buildspec file present at the root of the code repository

![image](https://user-images.githubusercontent.com/62248521/114949594-9f795280-9e51-11eb-9973-e37db3c3ab7c.png)

Code pipeline can also be utilized end to end to deploy it to EKS cluster. 

EKS deployments are done using Helm , the helm code is in a different repo : eks-helm. 


