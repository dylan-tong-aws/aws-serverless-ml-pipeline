# AWS Serverless ML Pipeline
author: [Dylan Tong](mailto:dylatong@amazon.com)

This is a low-code AWS machine learning pipeline automation solution build on AWS serverless components. 

The solution can be automatically deployed into your account using [CloudFormation](https://aws.amazon.com/cloudformation/). Quick-start instructions are provided below. The solution can be deployed and a working example can be launched with just a few steps.

### What does it do?

The following diagram is a logical archictecture for the solution. The pipeline consists of five main steps:

1. **Change detection:**  

![architecture](/images/logical-architecture.png)


### Quick-start Instructions

*Pre-requesites*:
* [An AWS Account](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc)
* [AWS CLI installed](https://aws.amazon.com/cli/)

**Step 1:** Deploy the CodePipeline CI/CD pipeline back-bone

<a href="https://console.aws.amazon.com/cloudformation/home?region=us-west-
2#/stacks/new?stackName=mlops-cicd&templateURL=https://dtong-public-fileshare.s3-us-west-2.amazonaws.com/aws-ml-pipeline/cf/mlops-cicd.yaml">
![launch stack button](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)</a>


**Step 2:** Wait for the 

test
