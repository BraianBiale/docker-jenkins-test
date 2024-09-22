# Start with the official Jenkins LTS base image
FROM jenkins/jenkins:lts

# Switch to the root user to install dependencies if needed
USER root

# Install any necessary dependencies (optional)
# RUN apt-get update && apt-get install -y some-package

# If you want to pre-install plugins, you can use the install-plugins.sh script
# RUN jenkins-plugin-cli --plugins "workflow-aggregator git"

# Optionally, copy your custom Jenkins configuration files
# COPY ./config.xml /var/jenkins_home/config.xml

# Set permissions on the Jenkins home directory (ensure jenkins owns its files)
RUN chown -R jenkins:jenkins /var/jenkins_home

# Expose the default Jenkins port
EXPOSE 8080

# Set the Jenkins user back for running Jenkins
USER jenkins

# Jenkins runs by default with this command
# ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]

# No need to specify CMD as it is already provided by the base image
