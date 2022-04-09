FROM centos

LABEL MAINTAINER="mobious_99@yahoo.com"

# Tomcat Source Download Parameters
ENV TOMCAT_VERSION="9.0.55"
ENV TOMCAT_DOWNLOAD_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
ENV TOMCAT_DOWNLOAD_HASH_FILE_URL="https://dlcdn.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512"
ENV TOMCAT_ARCHIVE_FILE="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
ENV TOMCAT_HASH_FILE="apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512"

# Java Source Download Parameters
ENV JDK_VERSION="11.0.1"
ENV JDK_DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz"
ENV JDK_DOWNLOAD_HASH_FILE_URL="https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz.sha512"
ENV JDK_ARCHIVE_FILE="openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz"
ENV JDK_HASH_FILE="openjdk-${JDK_VERSION}_linux-x64_bin.tar.gz.sha2"

# target JDK installation names
ENV OPT="/opt"
ENV JDK_DIR_NAME="jdk-${JDK_VERSION}"
ENV JAVA_HOME="${OPT}/${JDK_DIR_NAME}"
ENV JAVA_MINIMAL="${OPT}/java-minimal"

#Create scratch space
WORKDIR /tmp
RUN mkdir /opt/tomcat/
RUN mkdir /opt/java/

#Download the respective files
ADD "$TOMCAT_DOWNLOAD_URL" "$TOMCAT_DOWNLOAD_HASH_FILE_URL"
ADD "$JDK_DOWNLOAD_URL" "$JDK_ARJ_FILE"

# verify tomcat downloaded file hashsum
RUN { \
        echo "Verify downloaded tomcat file $TOMCAT_ARCHIVE_FILE:" && \
        #echo "$TOMCAT_HASH $TOMCAT_HAS_FILE" > "$TOMCAT_HASH_FILE" && \
        sha256sum -c "$TOMCAT_HASH_FILE" ; \
    }


# verify java downloaded file hashsum
RUN { \
        echo "Verify downloaded JDK file $JDK_ARCHIVE_FILE:" && \
        #echo "$JDK_HASH $JDK_ARJ_FILE" > "$JDK_HASH_FILE" && \
        sha256sum -c "$JDK_HASH_FILE" ; \
    }

# extract tomcat and add to PATH
RUN { \
        echo "Unpack downloaded Tomcat to ${JAVA_HOME}/:" && \
        mkdir -p "$OPT" && \
        tar xf "$TOMCAT_ARCHIVE_FILE" -C "$OPT" ; \
    }

# extract JDK and add to PATH
RUN { \
        echo "Unpack downloaded JDK to ${JAVA_HOME}/:" && \
        mkdir -p "$OPT" && \
        tar xf "$JDK_ARCHIVE_FILE" -C "$OPT" ; \
    }

ENV PATH="$PATH:$JAVA_HOME/bin"

#RUN curl -O https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.40/bin/apache-tomcat-8.5.40.tar.gz
RUN tar xvfz apache*.tar.gz
RUN mv apache-tomcat-8.5.40/* /opt/tomcat/.
RUN yum -y install java
RUN java -version

WORKDIR /opt/tomcat/webapps
RUN curl -O -L https://github.com/AKSarav/SampleWebApp/raw/master/dist/SampleWebApp.war
EXPOSE 8080
CMD ["/opt/tomcat/bin/catalina.sh", "run"]