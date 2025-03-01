FROM tomcat:9.0

# 必要なツールをインストール
RUN apt update && apt install -y python3 python3-pip wget curl \
    && rm -rf /var/lib/apt/lists/*

# pip をアップグレード & gdown をインストール
RUN python3 -m pip install --upgrade pip \
    && python3 -m pip install gdown

# GroupSession を Google Drive からダウンロード
RUN gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
