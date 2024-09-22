# Use a lightweight base image with OpenJDK (Alpine-based)
FROM openjdk:8-jdk-alpine

# Install curl and tini (for process handling)
RUN apk add --no-cache curl tini

# Environment variables
ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_VERSION=2.424  
# Use an appropriate Jenkins version
ENV JENKINS_URL=http://updates.jenkins-ci.org/download/war/${JENKINS_VERSION}/jenkins.war

# Create Jenkins home directory
RUN mkdir -p $JENKINS_HOME && \
    addgroup -S jenkins && adduser -S -G jenkins jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME

# Download Jenkins WAR
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war

# Expose Jenkins ports
EXPOSE 8080 50000

# Set Jenkins to run as user "jenkins"
USER jenkins

# Limit JVM heap size to reduce memory consumption
# Using -Xmx128m and -Xms64m to ensure minimal memory usage
CMD ["java", "-Xms64m", "-Xmx128m", "-jar", "/usr/share/jenkins/jenkins.war"]

# Use tini as the entrypoint for proper signal handling
ENTRYPOINT ["/sbin/tini", "--"]
