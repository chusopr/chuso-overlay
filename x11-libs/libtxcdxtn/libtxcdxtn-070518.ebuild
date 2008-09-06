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

src_install() {
        emake DESTDIR=${D} install || die "make install failed"
}
