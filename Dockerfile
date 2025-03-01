FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3 python3-pip && \
    apt remove -y python3-wheel && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# pip のアップグレード（Debian の `wheel` を削除した後に実行）
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel --break-system-packages

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN python3 -m gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
