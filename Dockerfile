FROM tomcat:jre25-temurin-noble
COPY target/sample-webapp2-1.1.war /usr/local/tomcat/webapps/sample-webapp.war