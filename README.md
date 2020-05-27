# docker-android-node

[gabrielepmattia/docker-android-alpine:latest](https://hub.docker.com/r/gabrielepmattia/docker-android-node)

This Docker image contains the Android SDK, NodeJS+NPM and the most common packages necessary for building Android Apps (also based on, for example, React Native) in a CI tool like GitLab CI. Make sure your CI environment's caching works as expected, this greatly improves the build time, especially if you use multiple build jobs.

A `.gitlab-ci.yml` with caching of your project's dependencies would look like this:

```
image: gabrielepmattia/docker-android-node

stages:
- build

before_script:
- export GRADLE_USER_HOME=$(pwd)/.gradle
- chmod +x ./gradlew

cache:
  key: ${CI_PROJECT_ID}
  paths:
  - .gradle/

build:
  stage: build
  script:
  - ./gradlew assembleDebug
  artifacts:
    paths:
    - app/build/outputs/apk/app-debug.apk
```

## Credits

- [Preventis](https://github.com/Preventis) for the original docker android image
