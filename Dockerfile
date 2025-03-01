FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt remove -y python3-wheel && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# pip のアップグレード（1回のみ）
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel --break-system-packages

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN python3 -m gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
