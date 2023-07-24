#!/bin/bash

# x86_64 or aarch64
ARCH="x86_64"
#ARCH="aarch64"

# Path to Xen project source code
XEN_DIR_X86="/path/to/xen/project/xen/x86"
XEN_DIR_ARCH64="/path/to/xen/project/xen/aarch64"
# Path to bindgen binary
BINDGEN="/path/to/bindgen/"

if [ "$ARCH" = "x86_64" ]; then
	${BINDGEN}/bindgen wrapper_x86_64.h -o src/xen_bindings_x86_64.rs \
	--ignore-functions \
	--ignore-methods \
	--no-layout-tests \
	--use-core \
	--ctypes-prefix=xen_bindings_x86_64_types \
	-- \
	-D__XEN_TOOLS__ \
	-D__GLIBC_USE\(...\)=0 \
	-D__BEGIN_DECLS=" " \
	-D__END_DECLS=" " \
	-D__THROW=" " \
	-D__THROWNL=" " \
	-D__nonnull\(...\)=" " \
	-D__wur=" " \
	-D__gnuc_va_list="void *" \
	-I${XEN_DIR_X86}/tools/include/ \
	-I${XEN_DIR_X86}/xen/arch/x86/include/ \
	-I${XEN_DIR_X86}/xen/include/ \
	-I${XEN_DIR_X86}/xen/include/xen/ \
	-I${XEN_DIR_X86}/xen/include/public/
elif [ "$ARCH" = "aarch64" ]; then
	${BINDGEN}/bindgen wrapper_aarch64.h -o src/xen_bindings_aarch64.rs \
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
	-D_STDINT_H \
	-D_UNISTD_H \
	-D__XEN_TOOLS__ \
	-D__GLIBC_USE\(...\)=0 \
	-D__BEGIN_DECLS=" " \
	-D__END_DECLS=" " \
	-D__THROW=" " \
	-D__THROWNL=" " \
	-D__nonnull\(...\)=" " \
	-D__wur=" " \
	-D__gnuc_va_list="void *" \
	-I${XEN_DIR_ARCH64}/tools/include/ \
	-I${XEN_DIR_ARCH64}/xen/arch/arm/include/ \
	-I${XEN_DIR_ARCH64}/xen/include/ \
	-I${XEN_DIR_ARCH64}/xen/include/xen/ \
	-I${XEN_DIR_ARCH64}/xen/include/public/
fi
