FROM tomcat:9.0

# GroupSession をダウンロードして配置
RUN apt update && apt install -y wget \
    && wget https://example.com/path/to/GroupSession5.war -O /usr/local/tomcat/webapps/groupsession.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
