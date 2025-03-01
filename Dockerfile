FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3-full python3-venv curl wget unzip gettext-base && \
    rm -rf /var/lib/apt/lists/*

# GroupSession の WAR ファイルをダウンロード
RUN wget -O /usr/local/tomcat/webapps/groupsession.war \
    https://github.com/kenty-25/gsession/releases/download/v1.0.0/gsession.war && \
    ls -lh /usr/local/tomcat/webapps/groupsession.war || (echo "Download failed!" && exit 1)

# WAR ファイルを展開
RUN cd /usr/local/tomcat/webapps/ && \
    unzip -o groupsession.war -d groupsession && \
    rm groupsession.war

# Tomcat 設定を修正
RUN sed -i 's/<Server port="[^"]*"/<Server port="-1"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/<Connector port="[^"]*"/<Connector port="8080" address="0.0.0.0"/' /usr/local/tomcat/conf/server.xml

# 環境変数を設定
ENV PATH="/opt/venv/bin:$PATH"
ENV PORT=8080

# コンテナのポートを明示的に公開
EXPOSE 8080

# Health Check を追加
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/groupsession || exit 1

# Tomcat 起動前にポート設定を確認
CMD cat /usr/local/tomcat/conf/server.xml | grep 'Connector port="' && \
    exec catalina.sh run
