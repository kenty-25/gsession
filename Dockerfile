FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3 python3-venv curl && \
    rm -rf /var/lib/apt/lists/*

# Python のバージョン確認
RUN python3 --version

# get-pip.py を使って pip をインストール（公式推奨）
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# pip のバージョン確認（インストールが成功しているかチェック）
RUN python3 -m pip --version

# PEP 668 に対応しつつ pip をアップグレード
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# gdown のインストール
RUN python3 -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war || true

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
