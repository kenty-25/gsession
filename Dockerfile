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

# **Tomcat のポートを Render の PORT に変更**
RUN sed -i 's/port="8080"/port="'${PORT}'"/' /usr/local/tomcat/conf/server.xml

# Tomcat を起動
CMD ["sh", "-c", "exec catalina.sh run"]
