
PRE_FILE	= templates/10_ub-vcpe.part
POST_FILE 	= templates/30_ub-vcpe.part

INC_CONTROLLER	= templates/controller-disklayout-1.inc
INC_COMPUTE	= templates/compute-disklayout-1.inc
INC_STORAGE	= templates/storage-disklayout-1.inc
INC_NETWORK	= templates/network-disklayout-1.inc

OUT_CONTROLLER	= auto-vcpe-controller-disklayout-1.seed
OUT_COMPUTE	= auto-vcpe-compute-disklayout-1.seed
OUT_STORAGE	= auto-vcpe-storage-disklayout-1.seed
OUT_NETWORK	= auto-vcpe-network-disklayout-1.seed

KICKSTARTS_ROOT = $(COBBLER_ROOT)/kickstarts

install: prereq install_controller install_storage install_compute install_network

prereq:
	install -d $(KICKSTARTS_ROOT) -m 0755	

build: build_controller build_compute build_storage build_network

build_controller:
	cat $(PRE_FILE) $(INC_CONTROLLER) $(POST_FILE) > $(OUT_CONTROLLER)
build_compute:
	cat $(PRE_FILE) $(INC_COMPUTE) $(POST_FILE) > $(OUT_COMPUTE)
build_storage:
	cat $(PRE_FILE) $(INC_STORAGE) $(POST_FILE) > $(OUT_STORAGE)
build_network:
	cat $(PRE_FILE) $(INC_NETWORK) $(POST_FILE) > $(OUT_NETWORK)


install_controller: prereq build_controller
	install $(OUT_CONTROLLER) $(KICKSTARTS_ROOT)/$(OUT_CONTROLLER) -m 0644

install_compute: prereq build_compute
	install $(OUT_COMPUTE) $(KICKSTARTS_ROOT)/$(OUT_COMPUTE) -m 0644

install_storage: prereq build_storage
	install $(OUT_STORAGE) $(KICKSTARTS_ROOT)/$(OUT_STORAGE) -m 0644

install_network: prereq build_network
	install $(OUT_NETWORK) $(KICKSTARTS_ROOT)/$(OUT_NETWORK) -m 0644


clean:
	rm *.seed
