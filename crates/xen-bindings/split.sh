#!/bin/bash

# x86_64 or aarch64
ARCH="x86_64"
#ARCH="aarch64"

# Path to Xen project source code
XEN_DIR_X86="/media/mpoirier/passport/work/stratos/xen/x86/xen"
XEN_DIR_ARCH64="/media/mpoirier/passport/work/stratos/xen/arm64/xen"
# Path to bindgen binary
BINDGEN="/home/mpoirier/work/stratos/bindgen/target/debug/"

if [ "$ARCH" = "x86_64" ]; then
	${BINDGEN}/bindgen wrapper_xen_x86_64.h -o src/xen_bindings_xen_x86_64.rs \
	--ignore-functions \
	--ignore-methods \
	--no-layout-tests \
	--use-core \
	--ctypes-prefix=xen_bindings_x86_64_types \
	-- \
	-D__XEN_TOOLS__ \
	-I${XEN_DIR_X86}/xen/include/ \
	-I${XEN_DIR_X86}/xen/include/public/

	${BINDGEN}/bindgen wrapper_tools_x86_64.h -o src/xen_bindings_tools_x86_64.rs \
	--ignore-functions \
	--ignore-methods \
	--no-layout-tests \
	--use-core \
	--ctypes-prefix=xen_bindings_x86_64_types \
	--allowlist-file=.*xenctrl.h \
	--allowlist-file=.*xendevicemodel.h \
	--allowlist-file=.*xengnttab.h \
	--allowlist-file=.*xenstore.h \
	-- \
	-D__XEN_TOOLS__ \
	-I${XEN_DIR_X86}/dist/install/usr/local/include/ \
	-I${XEN_DIR_X86}/dist/install/usr/local/include/xen/sys/

elif [ "$ARCH" = "aarch64" ]; then
	${BINDGEN}/bindgen wrapper_xen_aarch64.h -o src/xen_bindings_xen_aarch64.rs \
	--ignore-functions \
	--ignore-methods \
	--no-layout-tests \
	--use-core \
	--ctypes-prefix=xen_bindings_aarch64_types \
	-- \
	-U__i386__ \
	-U__x86_64__ \
	-D__aarch64__ \
	-DCONFIG_ARM_64 \
	-D__XEN_TOOLS__ \
	-I${XEN_DIR_ARCH64}/xen/include/ \
	-I${XEN_DIR_ARCH64}/xen/include/public/
	
	${BINDGEN}/bindgen wrapper_tools_aarch64.h -o src/xen_bindings_tools_aarch64.rs \
	--ignore-functions \
	--ignore-methods \
	--no-layout-tests \
	--use-core \
	--ctypes-prefix=xen_bindings_aarch64_types \
	--allowlist-file=.*xenctrl.h \
	--allowlist-file=.*xendevicemodel.h \
	--allowlist-file=.*xengnttab.h \
	--allowlist-file=.*xenstore.h \
	-- \
	-D__aarch64__ \
	-DCONFIG_ARM_64 \
	-D__XEN_TOOLS__ \
	-I${XEN_DIR_AARCH64}/dist/install/usr/local/include/ \
	-I${XEN_DIR_AARCH64}/dist/install/usr/local/include/xen/sys/
fi

