FROM mysql:latest

# Set up the password and the database name
ENV MYSQL_ROOT_PASSWORD=Strong@Independent1Password
ENV MYSQL_DATABASE=bd_cabinetmedicale

# Set up the database schema. The following line will result in having a database with tables and content
# To avoid any problems you need to make sure that your SQL code works fine.
ADD ./resources/dataBases.sql /docker-entrypoint-initdb.d

WORKDIR /usr/local/tomcat

# Copy the tomcat directory from tomcateside to this image
COPY --from=tomcatside /usr/local/tomcat /usr/local/tomcat

# Set up tomcat, and JDK
WORKDIR /usr/local/tomcat/webapps

ENV CATALINA_BASE=/usr/local/tomcat
ENV CATALINA_HOME=/usr/local/tomcat
ENV CATALINA_TMPDIR=usr/local/tomcat/temp
ENV JRE_HOME=/usr
ENV CLASSPATH=/usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar

RUN apt-get update && \
    apt-get install openjdk-11-jdk -y && \
    apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f && \
    java -version

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk

RUN export JAVA_HOME && \
    export CATALINA_BASE && \
    export CATALINA_HOME && \
    export CATALINA_TMPDIR && \
    export JRE_HOME && \
    export CLASSPATH

# WORKDIR /var/run

# RUN cp mysqld/ mysqld.bc -rf
# RUN chown mysql:mysql mysqld.bc/

EXPOSE 8080

# Run the application
WORKDIR /usr/local/tomcat/bin
RUN chmod +x catalina.sh

CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]