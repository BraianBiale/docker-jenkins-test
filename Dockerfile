# Use a lightweight openjdk-alpine image as the base
FROM openjdk:8-jdk-alpine

# Install minimal dependencies required for Jenkins
RUN apk add --no-cache curl bash git tini

# Define environment variables
ENV JENKINS_HOME=/var/jenkins_home
ENV JENKINS_VERSION=2.424  # Choose the desired version of Jenkins
ENV JENKINS_URL=http://updates.jenkins-ci.org/download/war/${JENKINS_VERSION}/jenkins.war

# Create Jenkins home directory
RUN mkdir -p $JENKINS_HOME && \
    addgroup -S jenkins && adduser -S -G jenkins jenkins && \
    chown -R jenkins:jenkins $JENKINS_HOME

# Download the Jenkins WAR file
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war

# Expose Jenkins ports (8080 for the web interface, 50000 for agents)
EXPOSE 8080 50000

# Use Tini to handle signals (for proper container termination)
ENTRYPOINT ["/sbin/tini", "--"]

# Run Jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]

# Set user to Jenkins
USER jenkins
