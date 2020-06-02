# AWS Serverless ML Pipeline
author: [Dylan Tong](mailto:dylatong@amazon.com)

This is a low-code AWS machine learning pipeline automation solution built on AWS serverless components. 

The solution can be automatically deployed into your account using [CloudFormation](https://aws.amazon.com/cloudformation/). Quick-start instructions are provided below. The solution can be deployed and a working example can be launched with just a few steps.

### What does it do?

The following diagram is a logical archictecture for the solution. 

![architecture](/images/logical-architecture.png)


---

The pipeline consists of five main steps:

<img src="images/codepipeline-cicd.png" width="80%"/>

---

1. **Change detection:** Changes to assets such as code, configurations and data can trigger the pipeline to run. Triggers include git pushes to the master branch in [CodeCommit](https://aws.amazon.com/codecommit/), or changes to data sets in your S3 bucket.

2. **Build Test and Stage Environment:** The pipeline dynamically builds a test environment as defined by the provided CloudFormation templates. The environment consists of two parts: 

      * The first is a machine learning pipeline built on AWS Step Functions. The purpose of the pipleine is to train, evaluate and deploy ML models. It can be reconfigured through the ML pipeline [template](/cf/mlops-ml-pipeline.yaml) and this [configuration file](/config/ml-pipeline-config.json)

      * The second is the test environment consisting of your application and test suites. The environment can be configured through the following [template](/cf/mlops-test-env.yaml). The provided template deploys a simple microservice consisting of a [AWS Lambda](https://aws.amazon.com/lambda/) function front by [Amazon API Gateway](https://aws.amazon.com/api-gateway/). It communicates with the [Amazon SageMaker](https://aws.amazon.com/sagemaker/) hosted endpoint that is configured in the aforementationed [configuration file](/config/ml-pipeline-config.json). It also deploys a sample test suite that runs on Lambda.
      
3. **Run the ML Pipeline:** The image below illustrates the the Step function workflow of the provided ML pipeline. The pipeline starts with a data prep step executed by [AWS Glue](https://aws.amazon.com/glue/). Next, a customer churn prediction model is trained using XGBoost and this job is tracked as by [SageMaker Experiments](https://aws.amazon.com/sagemaker/) for traceability. The train model is evaluated, and if it meets the performance criteria, the workflow proceeds to deploy the model as a SageMaker hosted endpoint. The worfklow completes successfully once the hosted endpoint reports an in-service status. If the endpoint already exists, a model variant is deployed and the endpoint is updated.

<img src="/images/sfn-ml-pipeline.png" width="65%"/>

4. **Test Automation:** Once the ML pipeline delivers a healthy model serving endpoint, we can run our test suites against our model server. The provided [test](tests/) is only meant to serve as an example. It simply invokes the endpoint and reports back the predicton results.

5. **Deploy to Production:** Once the test completes, a manual approval process is required before the changes are deployed into production. Test results can be reported externally or as output variables in CodePipeline. Information gathered in SageMaker Experiments and CloudWatch are also valuable. Once the approver reviews and approves the changes, training and test results, the pipeline deploys the changes into production using this [template](cf/mlops-deploy-prod.yaml). The provided template deploys a new copy of the simple microservice. This is optionally deployed into a VPC with a [VPC endpoint](https://docs.aws.amazon.com/sagemaker/latest/dg/interface-vpc-endpoint.html). The API managed by API Gateway is promoted to production using a [carnary deploy](https://docs.aws.amazon.com/apigateway/latest/developerguide/create-canary-deployment.html). Finally, a SageMaker [Model Monitor](https://docs.aws.amazon.com/sagemaker/latest/dg/model-monitor.html) is deployed and is scheduled to evaluate data drift issues on an hourly basis.

### Design Patterns and Best Practices

The provided design isn't the only way to integrate your ML pipeline into an existing CI/CD CodePipeline. You could alternative have all your workflows orchestrated by AWS Step Functions and have both CodePipeline and the ML Pipeline contained within a Step Function workflow.

This design provides the benefit of better consistency. However, there're trade-offs. The above design better decouples the CI/CD pipeline from the ML pipeline. This is ideal for the common case where a CI/CD pipeline already exists and you would like to minimize changes to your core application delivery system. This design augments the existing CI/CD pipeline with a ML pipeline that runs in Step Functions with minimal coupling and dependencies between the systems. Thus, this integration strategy poses less risks and disruption.

Secondly, at this point in time, Step Functions is best design to orchestrate systems running exclusively in the AWS cloud. The design pattern prescribed is more flexible. You could replace the CodePipeline backbone in this solution with an on-premise CI/CD solution. The other parts of the pipeline are decoupled and could run in the cloud as part of a hybrid cloud architecture.

### Quick-start Instructions

*Pre-requesites*:
* [An AWS Account](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc)
* [AWS CLI installed](https://aws.amazon.com/cli/)
* [Setup SSH connections for CodeCommit](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html)

**Step 1:** Deploy the CodePipeline CI/CD pipeline back-bone

*The launch button defaults to us-west-2, but you can change the region from the console.*

<a href="https://console.aws.amazon.com/cloudformation/home?region=us-west-
2#/stacks/new?stackName=mlops-cicd&templateURL=https://dtong-public-fileshare.s3-us-west-2.amazonaws.com/aws-ml-pipeline/cf/mlops-cicd.yaml">
![launch stack button](https://s3.amazonaws.com/cloudformation-examples/cloudformation-launch-stack.png)</a>


**Step 2:** Wait for template to reach the create complete status.

![cicd](/images/cf-stack-ready.png)

**Step 3:** Trigger your pipeline to run

If you're running on a Mac OS, you can simply download and run this [shell script](https://raw.githubusercontent.com/dylan-tong-aws/aws-serverless-ml-pipeline/master/bootstrap/quick-start-mac-osx.sh).

If not, git clone this repository and git push all the assets to the CodeCommit repository created in step 1. By default, the CodeCommit repository is called mlops-repo. 

Specifically, the steps are:

1. git clone https://github.com/dylan-tong-aws/aws-serverless-ml-pipeline.git ./tmp
2. git clone ssh://git-codecommit.\<Insert Your Selected AWS Region\>.amazonaws.com/v1/repos/mlops-repo
3. Copy the contents in the "tmp" directory to the "mlops-repo" directory.
4. From within the mlops-repo directory:
     * git add -A
     * git commit -m "aws ml pipeline assets"
     * git push

You can monitor the pipeline progression from the CodePipeline and AWS Step Functions console. Enjoy!
