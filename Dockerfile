FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Python & pip のバージョン確認（デバッグ用）
RUN python3 --version && python3 -m pip --version

# PEP 668 に対応して pip をアップグレード
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel --break-system-packages

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown --break-system-packages

# Google Drive から GroupSession をダウンロード
RUN gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
