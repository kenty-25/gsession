FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3-full python3-venv curl wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Python のバージョン確認
RUN python3 --version

# 仮想環境を作成し、pip を確実にインストール
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/python -m ensurepip && \
    /opt/venv/bin/python -m pip install --upgrade pip setuptools wheel

# gdown のインストール（バックアップ用）
RUN /opt/venv/bin/python -m pip install --no-cache-dir gdown

# Google Drive から GroupSession をダウンロード（gdown が失敗した場合は wget を使用）
RUN wget -O /usr/local/tomcat/webapps/groupsession.war \
    https://github.com/kenty-25/gsession/releases/download/v1.0.0/gsession.war && \
    ls -lh /usr/local/tomcat/webapps/groupsession.war || (echo "Download failed!" && exit 1)


# WAR ファイルを展開
RUN cd /usr/local/tomcat/webapps/ && \
    unzip -o groupsession.war -d groupsession && \
    rm groupsession.war

# 環境変数を設定
ENV PATH="/opt/venv/bin:$PATH"

# ポートを公開し、Tomcat を実行
EXPOSE 8080
CMD ["sh", "-c", "exec catalina.sh run"]
