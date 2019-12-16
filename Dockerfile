FROM alpine as builder
RUN \
	apk add build-base git autoconf automake pkgconf confuse-dev && \
	git clone https://github.com/troglobit/mini-snmpd.git && \
	cd mini-snmpd && \
	./autogen.sh && \
	./configure && \
	make && \
	strip mini_snmpd

FROM alpine
COPY --from=builder /mini-snmpd/mini_snmpd /sbin/snmpd
RUN \
	apk add --no-cache confuse && \
	rm -rf /var/cache/apk/*

ENTRYPOINT ["/sbin/snmpd"]
CMD ["-n"] 
