# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

MY_PN="libtxc_dxtn"
MY_P="${MY_PN}${PV}"

DESCRIPTION="S3TC for DRI"
HOMEPAGE="http://homepage.hispeed.ch/rscheidegger/dri_experimental/s3tc_index.html"
SRC_URI="http://homepage.hispeed.ch/rscheidegger/dri_experimental/${MY_P}.tar.gz"
LICENSE="S3TC"
SLOT="0"
KEYWORDS="-*"
IUSE=""

RESTRICT="mirror"

RDEPEND=""
DEPEND="${RDEPEND}
	media-libs/mesa"

S="${WORKDIR}/${MY_PN}"

pkg_setup()
{
	ewarn "ATTENTION!!!"
	ewarn "This library included patented algorithms so you may be infringing"
	ewarn "patent rights by emerging it."
	ewarn "It's your responsibility to be sure to be in a right legal situation"
	ewarn "before emerging this package."
	ewarn "ATTENTION!!!"
}

src_install() {
	emake DESTDIR=${D} install || die "make install failed"
}

pkg_postinst()
{
	ewarn "ATTENTION!!!"
	ewarn "This library included patented algorithms so you may be infringing"
	ewarn "patent rights by emerging it."
	ewarn "It's your responsibility to be sure to be in the right legal	situation."
	ewarn "If don't, please remove this package, God kills a kitten every time"
	ewarn "you piracy Software."
	ewarn "ATTENTION!!!"
}
