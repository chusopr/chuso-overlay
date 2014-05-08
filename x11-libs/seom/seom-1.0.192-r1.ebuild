# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
#MULTILIB_COMPAT=( abi_x86_{32,64} )

#inherit multilib toolchain-funcs
#inherit multilib multilib-build
inherit multilib-minimal multilib-build

MY_COMMIT="b30306d9bcd5f2c7690bbb5323079dfe1dee4ced"

DESCRIPTION="OpenGL video capturing library"
HOMEPAGE="http://neopsis.com/projects/seom"
SRC_URI="https://github.com/wereHamster/${PN}/archive/${MY_COMMIT}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=">=dev-lang/yasm-0.6.0"

S=${WORKDIR}
MY_S="${WORKDIR}/${PN}-${MY_COMMIT}"

my_unpack()
{
	mkdir "${BUILD_DIR}" &&
	cd "${BUILD_DIR}" &&
	unpack ${A}
	echo ${PV} > ${PN}-${MY_COMMIT}/VERSION
}

src_unpack()
{
	multilib_foreach_abi my_unpack
}

multilib_src_configure()
{
	cd "${BUILD_DIR}/${PN}-${MY_COMMIT}"
	if ( [ ${ABI} == "x86" ] && ! multilib_is_native_abi )
	then
		setarch i686 ./configure --prefix=/usr
	else
		econf
	fi
}

multilib_src_compile()
{
	cd "${BUILD_DIR}/${PN}-${MY_COMMIT}"
	if ( [ ${ABI} == "x86" ] && ! multilib_is_native_abi )
	then
		emake CC="${CC} -m32" LIBDIR=lib32
	else
		emake
	fi
}

multilib_src_install()
{
	cd "${BUILD_DIR}/${PN}-${MY_COMMIT}"
	if ( [ ${ABI} == "x86" ] && ! multilib_is_native_abi )
	then
		emake DESTDIR="${D}" LIBDIR=lib32 install || die
	else
		emake DESTDIR="${D}" install || die
	fi
}
