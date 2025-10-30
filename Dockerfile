# Use official Tomcat 9 with JDK 11 (stable for JSP apps)
FROM tomcat:9.0-jdk11

# Remove default webapps to keep container clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your app as ROOT.war so it's served at /
COPY ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
