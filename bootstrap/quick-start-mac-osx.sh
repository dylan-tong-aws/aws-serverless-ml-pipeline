echo "In what region did you deploy your pipeline?"
read region
if echo $region | grep -q "us-east-1\|us-east-2\|us-west-1\|us-west-2\|ap-east-1\|ap-northeast-1\|ap-northeast-2\|ap-south-1\|ap-southeast-1\|ap-southeast-2\|ca-central-1\|cn-north-1\|cn-northwest-1\|eu-central-1\|eu-north-1\|eu-west-1\|eu-west-2\|eu-west-3\|me-south-1\|sa-east-1\|us-gov-west-1"
then       
    git clone https://github.com/dylan-tong-aws/aws-serverless-ml-pipeline.git ./tmp
    git clone ssh://git-codecommit.$region.amazonaws.com/v1/repos/mlops-repo
    mv ./tmp/* ./mlops-repo/
    rm -rf ./tmp
    cd mlops-repo
    git add -A
    git commit -m "aws ml pipeline assets"
    git push
else
    echo $region "isn't a supported AWS region."
fi