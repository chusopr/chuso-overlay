# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-nop/slf4j-nop-1.5.11.ebuild,v 1.5 2010/10/14 17:01:55 ranger Exp $

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/jul-to-/}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="~dev-java/slf4j-api-${PV}:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	app-arch/unzip"

S="${WORKDIR}/${P/jul-to-/}/${PN}"

EANT_GENTOO_CLASSPATH="slf4j-api,log4j,junit"

java_prepare() {
	cp -v "${FILESDIR}"/build.xml . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/main/java/org
}
