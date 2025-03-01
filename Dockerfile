FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3-full python3-venv curl wget && \
    rm -rf /var/lib/apt/lists/*

# Python のバージョン確認
RUN python3 --version

# 仮想環境を作成し、pip を確実にインストール
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m ensurepip && \
    /opt/venv/bin/python -m pip install --upgrade pip setuptools wheel

# pip のバージョン確認
RUN /opt/venv/bin/python -m pip --version

# gdown のインストール
RUN /opt/venv/bin/python -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード
RUN /opt/venv/bin/python -m gdown --id 1UOogBdYXtNCc6jOvGZPymxaV6AOz1ris -O /usr/local/tomcat/webapps/groupsession.war || true

# 環境変数を設定（仮想環境をデフォルトに）
ENV PATH="/opt/venv/bin:$PATH"

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["catalina.sh", "run"]
