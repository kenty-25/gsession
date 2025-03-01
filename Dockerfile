FROM tomcat:9.0

# 作業ディレクトリの設定
WORKDIR /usr/local/tomcat/webapps

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3 && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Python & pip のバージョン確認（デバッグ用）
RUN python3 --version && python3 -m ensurepip && python3 -m pip --version

# pip のアップグレード
RUN python3 -m ensurepip --default-pip && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O groupsession.war

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
