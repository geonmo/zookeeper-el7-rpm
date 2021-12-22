.PHONY:	rpm clean

VERSION ?= 3.7.0
BUILD_NUMBER ?= 1
SOURCE = apache-zookeeper-$(VERSION)-bin.tar.gz
TOPDIR = /tmp/zookeeper-rpm
PWD = $(shell pwd)
URL = https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-$(VERSION)/$(SOURCE)

rpm: $(SOURCE)
	@rpmbuild -v -bb \
			--define "_sourcedir $(PWD)" \
			--define "_rpmdir $(PWD)/RPMS" \
			--define "_topdir $(TOPDIR)" \
			--define "version $(VERSION)" \
			--define "build_number $(BUILD_NUMBER)" \
			zookeeper.spec

source: $(SOURCE)

$(SOURCE): KEYS $(SOURCE).asc
	@curl -O $(URL)
	gpg --verify $(SOURCE).asc $(SOURCE)

clean:
	@rm -rf $(TOPDIR) x86_64
	@rm -f $(SOURCE)

$(SOURCE).asc:
	@wget -q https://dist.apache.org/repos/dist/release/zookeeper/zookeeper-$(VERSION)/$(SOURCE).asc

KEYS:
	@wget -q https://dist.apache.org/repos/dist/release/zookeeper/KEYS
	gpg --import KEYS
