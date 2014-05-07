# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-pkg-simple java-utils-2
MY_PN=${PN/-/}
DESCRIPTION="P2P radio streaming"
HOMEPAGE="http://p2p-radio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/P2P-Radio-2.0-src.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

JAVA_ENCODING="ISO-8859-1"

src_compile() {
	mkdir -p target/classes/p2pradio/gui &&
	cp ${MY_PN}/${MY_PN}*.properties target/classes/${MY_PN} &&
	cp ${MY_PN}/gui/Icon.png target/classes/${MY_PN}/gui &&
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher "${PN}" --main p2pradio.tools.VersionChecker
	newicon -s 48 "${MY_PN}/gui/Icon.png" p2p-radio.png
	make_desktop_entry p2p-radio "P2P Radio" p2p-radio "Audio;AudioVideo;Network;P2P;Player"
}
