# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-utils-2
MY_PN=${PN/-/}
DESCRIPTION="P2P radio streaming"
HOMEPAGE="http://p2p-radio.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/P2P-Radio-2.0-src.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

src_compile() {
	ejavac -encoding ISO-8859-1 p2pradio/Radio.java
}

src_install() {
	jar -cf "${PN}.jar" "${MY_PN}"/*.class "${MY_PN}"/*/*/*.class "${MY_PN}"/*/*.class "${MY_PN}"/gui/Icon.png
	insinto "/usr/share/${PN}"
	doins "${PN}.jar"
	java-pkg_regjar "${D}/usr/share/${PN}/${PN}.jar"
	java-pkg_dolauncher "${PN}" --main p2pradio.tools.VersionChecker
}
