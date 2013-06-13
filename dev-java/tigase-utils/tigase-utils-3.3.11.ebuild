# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-nop/slf4j-nop-1.5.11.ebuild,v 1.5 2010/10/14 17:01:55 ranger Exp $

EAPI="5"
JAVA_PKG_IUSE="doc source"

EGIT_REPO_URI="https://repository.tigase.org/git/${PN}"
EGIT_COMMIT=${P}

inherit git-2 eutils java-pkg-2 java-ant-2

DESCRIPTION="Utility classes which can be used outside of the Tigase server project."
HOMEPAGE="https://projects.tigase.org/projects/tigase-utils"
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-java/ant-1.7
	>=dev-java/tigase-xmltools-3.0
	>=virtual/jdk-1.6.0"

RDEPEND=">=dev-java/tigase-xmltools-3.0
	>=virtual/jre-1.6.0"

EANT_GENTOO_CLASSPATH="tigase-xmltools,junit"

java_prepare() {
	cp -v "${FILESDIR}"/build.xml . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/main/java/*
}