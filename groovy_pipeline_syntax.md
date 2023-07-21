  ### Pipeline syntax in Groovy

```
stage('Load environment properties') {
    common = load("config/ci/jenkins/pipeline/common.groovy")
    props = common.loadEnvProperties()
  }
```
Function name:
```
def void ABCFUNCNAME(String path, String scriptBody) {
  sh '''#!/bin/bash
  ''' + scriptBody + '''
  path=`pwd` && cd RLEASE_FOLDER && . load_FILE.sh ${ENVIRONMENT} ${CLIENT} && cd ${path}
  regexp=".*\\:\\s*\\S+"
  cat ''' + path + ''' | while read line || [ -n "$line" ]; \
  do \
    eval_line=$(eval echo `echo $line`); \
    [[ $eval_line =~ $regexp ]] && echo $eval_line; \
  done \
  > ''' + path + '''.out.yaml
  cat ''' + path + '''.out.yaml 
 '''
}

```

Access:
props.function_name
