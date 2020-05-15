FROM ringcentral/jdk:8
LABEL maintainer="Gabriele Proietti Mattia <pm.gabriele@outlook.com>"

ENV VERSION_CMD_LINE_TOOLS "6200805"

ENV ANDROID_HOME "/sdk"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

RUN apk update
RUN apk add --no-cache bash bzip2 curl unzip git

RUN curl -s https://dl.google.com/android/repository/commandlinetools-linux-${VERSION_CMD_LINE_TOOLS}_latest.zip > /sdk.zip
RUN unzip /sdk.zip -d /sdk
RUN rm -v /sdk.zip

# accept licenses
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# update repositories
ADD packages.txt /sdk
RUN mkdir -p /root/.android
RUN touch /root/.android/repositories.cfg
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --update

RUN while read -r package; do PACKAGES="${PACKAGES}${package} "; done < /sdk/packages.txt && ${ANDROID_HOME}/tools/bin/sdkmanager ${PACKAGES}
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --licenses

# sonar scanner for code quality
ENV SONAR_SCANNER_VERSION 3.0.3.778
RUN apk add --no-cache wget && \ 
    curl -L -O  https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \ 
    ls -lh && \ 
    unzip sonar-scanner-cli-${SONAR_SCANNER_VERSION} && \ 
    cd /usr/bin && ln -s /sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner sonar-scanner && \ 
    ln -s /usr/bin/sonar-scanner-run.sh /bin/gitlab-sonar-scanner 
