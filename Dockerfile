FROM tomcat:9.0

# 必要なツールをインストールし、GroupSession をダウンロード
RUN apt update && apt install -y wget \
    && wget --no-check-certificate --progress=bar:force \
       "https://drive.google.com/file/d/1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris/view?usp=drive_link" \
       -O /usr/local/tomcat/webapps/groupsession.war \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
