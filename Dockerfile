FROM tomcat:9.0

# 必要なツールをインストールし、GroupSession をダウンロード
RUN apt update && apt install -y wget \
    && wget --no-check-certificate --progress=bar:force \
       "https://drive.google.com/uc?export=download&id=1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris" \
       -O /usr/local/tomcat/webapps/groupsession.war \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
