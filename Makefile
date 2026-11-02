BUILD?=build
DESTDIR?=$(CURDIR)/certs
NSS_VER=nss-3.132

all: $(DESTDIR)/ca-certificates.crt

clean:
	rm -rf build

$(BUILD)/$(NSS_VER).tar.gz:
	mkdir -p $(BUILD)
	cd $(BUILD) && \
		wget https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_132_RTM/src/nss-3.132.tar.gz

$(BUILD)/certdata.txt: $(BUILD)/$(NSS_VER).tar.gz
	cd $(BUILD) && \
		tar -xf $(NSS_VER).tar.gz && \
		cp $(NSS_VER)/nss/lib/ckfw/builtins/certdata.txt certdata.txt

$(BUILD)/etc: $(BUILD)/certdata.txt
	rm -rf $(BUILD)/etc $(CURDIR)/certs
	cd $(BUILD) && \
		../make-ca.sh -D $(shell realpath $(BUILD)) && \
		rsync -av --delete etc/ssl/certs/ $(DESTDIR)/

$(DESTDIR)/ca-certificates.crt: $(BUILD)/etc
	cp  $(BUILD)/etc/ssl/ca-bundle.crt $(DESTDIR)/ca-certificates.crt
