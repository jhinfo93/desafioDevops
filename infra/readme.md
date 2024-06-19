        


  aws ecs execute-command \
  --region us-east-1 \
  --cluster ecs-cluster-example \
  --task b4e57c02009e4fd392f7ff708fe14d51 \
  --container nginx \
  --command "/bin/sh" \
  --interactive 


  aws ecs update-service \
  --cluster ecs-cluster-example \
  --service next-service \
  --task-definition nginx-example:14 \
  --force-new-deployment \
  --enable-execute-command 


  aws ecs update-service --cluster ecs-cluster-example --service next-service --force-new-deployment --enable-execute-command