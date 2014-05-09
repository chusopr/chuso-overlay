# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="Open source DXT compression library"
HOMEPAGE="http://code.google.com/p/libsquish/"
SRC_URI="http://lib${PN}.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}/include_limits.patch"
}

src_install() {
	mkdir -p "${D}/usr"/{lib,include} || die
	einstall INSTALL_DIR="${D}/usr" || die
}
