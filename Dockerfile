FROM balenalib/armv7hf-debian

MAINTAINER Tloxipeuhca <tloxipeuhca@gmail.com>

ARG GF_VERSION

# Set environment variables
ENV GF_PATHS_CONFIG="/etc/grafana/grafana.ini"
ENV GF_PATHS_CONFIG_PATH="/etc/grafana"
ENV GF_PATHS_DATA="/var/lib/grafana"
ENV GF_PATHS_HOME="/usr/share/grafana"
ENV GF_PATHS_LOGS="/var/log/grafana"
ENV GF_PATHS_PLUGINS="/var/lib/grafana/plugins"
ENV GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

# Install dependencies
RUN apt-get update
RUN apt-get install -y iputils-ping tar wget rsync
RUN mkdir -p "$GF_PATHS_CONFIG_PATH" "$GF_PATHS_DATA" "$GF_PATHS_HOME" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"
WORKDIR "$GF_PATHS_HOME"
RUN wget https://dl.grafana.com/oss/release/grafana-8.2.3.linux-armv7.tar.gz
RUN tar xvzf $(ls . | grep ".tar.gz$" | head -1)
RUN rsync -arv $(ls . | grep "^grafana" | head -1)/ .
RUN rsync -arv ./bin/* /bin
RUN mv ./conf/provisioning/* "$GF_PATHS_PROVISIONING"
RUN cp ./conf/ldap.toml "$GF_PATHS_CONFIG_PATH"/ldap.toml

# Clean up
RUN rm $(ls . | grep ".tar.gz$" | head -1)
RUN rm -fR $(ls . | grep "^grafana" | head -1)
RUN rm -fR ./bin
RUN apt-get clean
RUN apt-get autoclean

# Expose port.
EXPOSE 3000

# Start
CMD ["/bin/grafana-server", "--config=/etc/grafana/grafana.ini", "--homepath=/usr/share/grafana"]
