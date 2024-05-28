version: 0.1
frontend:
  phases:
    preBuild:
      commands:
        - ls -lha
        - echo ${testeEnv1}
        - npm install
    build:
      commands:
        - ls -lha
        - echo ${testeEnv2}
        - npm run build
  artifacts:
    baseDirectory: .next
    files:
      - '**/*'
  cache:
    paths:
      - node_modules/**/*
      - .next/cache/**/*