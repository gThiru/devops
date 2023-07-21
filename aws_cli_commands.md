  ## AWS CLI frequent usable commands
#### To get a the AWS account ID into the variable in pipeline/groovy
```
accountId=sh(returnStdout: true, script: "aws sts get-caller-identity --query 'Account' --output text").trim()
```
#### To get a the AWS account ID into the variable in command line
```
accountId=$(aws sts get-caller-identity --query 'Account' --output text)
```

