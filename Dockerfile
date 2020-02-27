
FROM openjdk:8

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
ENV ANDROID_HOME="/usr/local/android-sdk-linux"

ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

WORKDIR /opt

RUN apt-get clean && \
    apt-get update && \
    apt-get -y install  -yq libc6 libstdc++6 zlib1g libncurses5 build-essential libssl-dev ruby ruby-dev --no-install-recommends curl gradle wget

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
    apt-get -y install nodejs

RUN npm i -g @ionic/cli cordova --unsafe-perm

RUN mkdir -p "${ANDROID_HOME}" && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip -d  ${ANDROID_HOME} && \
    rm tools.zip


# Make license agreement
RUN mkdir $ANDROID_HOME/licenses && \
    echo 8933bad161af4178b1185d1a37fbf41ea5269c55 > $ANDROID_HOME/licenses/android-sdk-license && \
    echo d56f5187479451eabf01fb78af6dfcb131a6481e >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 24333f8a63b6825ea9c5514f83c2829b004d1fee >> $ANDROID_HOME/licenses/android-sdk-license && \
    echo 84831b9409646a918e30573bab4c9c91346d8abd > $ANDROID_HOME/licenses/android-sdk-preview-license


RUN $ANDROID_HOME/tools/bin/sdkmanager "tools" "platform-tools" && \
    $ANDROID_HOME/tools/bin/sdkmanager "build-tools;28.0.3" "build-tools;27.0.3" && \
    $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-28" "platforms;android-27" && \
    $ANDROID_HOME/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository"

