# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

DESCRIPTION="C++ lua binding"
HOMEPAGE="http://www.rasterbar.com/products/luabind.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/lua"
DEPEND="
	dev-util/boost-build
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/boost_bug_6631.patch"
}

src_compile() {
	bjam release --prefix="${D}/usr/" link=shared toolset=gcc || die "compile failed"
}

src_install() {
	bjam release --prefix="${D}/usr/" link=shared toolset=gcc install || die "install failed"
}
