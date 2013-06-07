# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="doc source"

EGIT_REPO_URI="https://repository.tigase.org/git/${PN}"
EGIT_COMMIT=${P}

inherit git-2 java-pkg-2 java-ant-2

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

EANT_DOC_TARGET="docs"

java_prepare() {
	mkdir libs
	epatch "${FILESDIR}/xmltoolsjar.patch"

	sed -i -e "s:libs=libs:xmltoolsjar=$(java-pkg_getjar tigase-xmltools tigase-xmltools.jar):" build.properties
}

src_install() {
	java-pkg_dojar jars/*.jar
	use doc && java-pkg_dojavadoc docs-tigase-utils/api
	use source && java-pkg_dosrc src/main/java/
}
