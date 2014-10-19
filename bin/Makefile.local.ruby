ruby_ubuntu := /Users/Shared/ubuntu
UBUNTU1404_SERVER_AMD64 := $(ruby_ubuntu)/ubuntu-14.04.1-server-amd64.iso

VIRTUALBOX_VERSION := $(shell virtualbox --help | head -n 1 | awk '{print $$NF}')
VMWARE_BOX_FILES := $(wildcard box/vmware/*.box)
VIRTUALBOX_BOX_FILES := $(wildcard box/virtualbox/*.box)
VMWARE_S3_BUCKET := s3://box-cutter/ubuntu/vmware9.8.3/
VIRTUALBOX_S3_BUCKET := s3://box-cutter/ubuntu/virtualbox$(VIRTUALBOX_VERSION)/
CHEF_MISHESKA_S3_GRANT_ID := id=6efa364c53605afa1f4186b2b23ba97a354e74c7b9238317d9f57bc8f6f6bc5a
ALLUSERS_ID := uri=http://acs.amazonaws.com/groups/global/AllUsers

upload-s3: upload-s3-vmware upload-s3-virtualbox

upload-s3-vmware:
	@for vmware_box_file in $(VMWARE_BOX_FILES) ; do \
		aws s3 cp $$vmware_box_file $(VMWARE_S3_BUCKET) --storage-class REDUCED_REDUNDANCY --grants full=$(CHEF_MISHESKA_S3_GRANT_ID) read=$(ALLUSERS_ID) ; \
	done

upload-s3-virtualbox:
	@for virtualbox_box_file in $(VIRTUALBOX_BOX_FILES) ; do \
		aws s3 cp $$virtualbox_box_file $(VIRTUALBOX_S3_BUCKET) --storage-class REDUCED_REDUNDANCY --grants full=$(CHEF_MISHESKA_S3_GRANT_ID) read=$(ALLUSERS_ID) ; \
	done

test-vagrantcloud: test-vagrantcloud-vmware test-vagrantcloud-virtualbox

test-vagrantcloud-vmware:
	@for shortcut_target in $(SHORTCUT_TARGETS) ; do \
		bin/test-vagrantcloud-box.sh learningchef/$$shortcut_target vmware_fusion vmware_desktop $(CURRENT_DIR)/test/*_spec.rb || exit; \
	done

test-vagrantcloud-virtualbox:
	@for shortcut_target in $(SHORTCUT_TARGETS) ; do \
		bin/test-vagrantcloud-box.sh learningchef/$$shortcut_target virtualbox virtualbox $(CURRENT_DIR)/test/*_spec.rb || exit; \
	done
