FROM tomcat:9.0

# 必要なパッケージをインストールし、キャッシュを削除
RUN apt update && \
    apt install -y curl wget unzip && \
    rm -rf /var/lib/apt/lists/*

# GroupSession をダウンロード
RUN wget -O /usr/local/tomcat/webapps/groupsession.war \
    https://github.com/kenty-25/gsession/releases/download/v1.0.0/gsession.war

# WAR ファイルを展開
RUN cd /usr/local/tomcat/webapps/ && \
    unzip -o groupsession.war -d groupsession && \
    rm groupsession.war

# Tomcat のポート設定を Render の `PORT` に変更
RUN sed -i 's/port="8080"/port="'${PORT}'"/' /usr/local/tomcat/conf/server.xml

# 環境変数の適用
ENV CATALINA_OPTS="-Dserver.port=${PORT}"

# Tomcat を起動
CMD ["catalina.sh", "run"]
