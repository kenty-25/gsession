FROM tomcat:9.0

# gdown を使って Google Drive からダウンロード
RUN apt update && apt install -y python3 python3-pip wget \
    && pip install gdown \
    && gdown "https://drive.google.com/uc?export=download&id=1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris" \
       -O /usr/local/tomcat/webapps/groupsession.war \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
