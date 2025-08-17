FROM debian:trixie-slim

RUN set -eux; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		squid ca-certificates tzdata procps ssl-cert; \
	DEBIAN_FRONTEND=noninteractive apt-get remove --purge --auto-remove -y; \
	rm -rf /var/lib/apt/lists/*; \
	# Change default configuration to allow local network access \
	rm -f /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/private/ssl-cert-snakeoil.key; \
    mkdir -p /var/cache/squid; \
	# smoketest
	/usr/sbin/squid --version; \
	# create manifest \
	mkdir -p /usr/share/rocks; \
	(echo "# os-release" && cat /etc/os-release && echo "# dpkg-query" && dpkg-query -f '${db:Status-Abbrev},${binary:Package},${Version},${source:Package},${Source:Version}\n' -W) > /usr/share/rocks/dpkg.query

# debian13_x86_64でlinux-kernel-imageが150MBくらいだった
ENV CACHE_DIR="ufs /var/cache/squid 1000 16 256" \
    MAXIMUM_OBJECT_SIZE="256 MB" \
    CACHE_MEM="256 MB" \
	MAX_FILEDESCRIPTORS="1024"

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY squid/ /etc/squid/

EXPOSE 3128 3142
VOLUME /var/log/squid \
	/var/spool/squid
ENTRYPOINT ["entrypoint.sh"]
CMD ["-f", "/etc/squid/squid.conf", "-NYC"]
