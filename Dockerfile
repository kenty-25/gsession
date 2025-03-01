FROM tomcat:9.0

# 必要なパッケージをインストール
RUN apt update && apt install -y python3 python3-pip python3-setuptools python3-dev wget curl \
    && rm -rf /var/lib/apt/lists/*

# pip のアップグレード
RUN python3 -m pip install --upgrade pip setuptools wheel

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN wget --no-check-certificate -O /usr/local/tomcat/webapps/groupsession.war \
    "https://drive.google.com/uc?export=download&id=1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris"

EXPOSE 8080
CMD ["catalina.sh", "run"]
