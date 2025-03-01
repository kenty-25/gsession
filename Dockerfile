FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y python3-full python3-venv curl wget unzip && \
    rm -rf /var/lib/apt/lists/*

# GroupSession の WAR ファイルをダウンロード
RUN wget -O /usr/local/tomcat/webapps/groupsession.war \
    https://github.com/kenty-25/gsession/releases/download/v1.0.0/gsession.war && \
    ls -lh /usr/local/tomcat/webapps/groupsession.war || (echo "Download failed!" && exit 1)

# WAR ファイルを展開
RUN cd /usr/local/tomcat/webapps/ && \
    unzip -o groupsession.war -d groupsession && \
    rm groupsession.war

# 環境変数を設定
ENV PATH="/opt/venv/bin:$PATH"

# コンテナのポートを明示的に公開
EXPOSE 8080

# コンテナ起動時に環境変数 PORT を反映
CMD export PORT=${PORT:-8080} && \
    sed -i "s/<Connector port=\"[0-9]*\" protocol=\"HTTP\/1.1\"/<Connector port=\"${PORT}\" protocol=\"HTTP\/1.1\"/" /usr/local/tomcat/conf/server.xml && \
    grep 'Connector port="' /usr/local/tomcat/conf/server.xml && \
    exec catalina.sh run
