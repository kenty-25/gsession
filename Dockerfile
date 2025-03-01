FROM tomcat:9.0

# 必要なツールをインストール（分割）
RUN apt update && apt install -y python3 python3-pip wget \
    && pip3 install --upgrade pip \
    && pip3 install gdown

# GroupSession をダウンロード
RUN gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
