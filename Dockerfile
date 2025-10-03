# Use official Tomcat with JDK 17
FROM tomcat:10.1-jdk17

# Remove Tomcat default ROOT webapp so we use our app as ROOT
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the entire webapp (current directory) to Tomcat's ROOT webapp folder
COPY . /usr/local/tomcat/webapps/ROOT/

# If you use JDBC drivers (MySQL), include them in WEB-INF/lib
# e.g., add mysql-connector-java.jar to WEB-INF/lib before building the image

EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]