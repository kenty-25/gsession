# 使用するベースイメージとしてTomcatを指定
FROM tomcat:9.0

# 必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y wget unzip curl && \
    rm -rf /var/lib/apt/lists/*

# Javaのインストール（OpenJDK 11を使用）
RUN apt-get update && \
    apt-get install -y openjdk-11-jre && \
    java -version

# GroupSessionのWARファイルをダウンロード
RUN wget -O /usr/local/tomcat/webapps/groupsession.war https://github.com/kenty-25/gsession/releases/download/v1.0.0/gsession.war && \
    ls -lh /usr/local/tomcat/webapps/groupsession.war || (echo "Download failed!" && exit 1)

# GroupSession WARファイルを展開
RUN cd /usr/local/tomcat/webapps/ && \
    unzip -o groupsession.war -d groupsession && \
    rm groupsession.war

# Tomcatの設定を修正
RUN sed -i 's/<Server port="[^"]*"/<Server port="-1"/' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/<Connector port="[^"]*"/<Connector port="8080" address="0.0.0.0"/' /usr/local/tomcat/conf/server.xml

# WebSocket用のポート設定（必要に応じて）
RUN sed -i 's/<Connector port="8080" protocol="HTTP\/1.1"/<Connector port="8080" protocol="HTTP\/1.1" upgradeProtocols="websocket"/' /usr/local/tomcat/conf/server.xml

# 環境変数を設定
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# コンテナで公開するポート
EXPOSE 8080 8009

# Tomcatを起動するコマンド
CMD ["catalina.sh", "run"]
