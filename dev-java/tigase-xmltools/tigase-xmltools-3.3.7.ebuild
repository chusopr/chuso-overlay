# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

JAVA_PKG_IUSE="source"

EGIT_REPO_URI="https://repository.tigase.org/git/${PN}"
EGIT_COMMIT=${P}

inherit git-2 java-pkg-2 java-ant-2

DESCRIPTION="Tigase XML Tools used for fast and low resource XML parsing"
HOMEPAGE="https://projects.tigase.org/projects/tigase-xmltools"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-java/ant-1.7
	>=virtual/jdk-1.6.0
	dev-java/ant-contrib"

RDEPEND=">=virtual/jre-1.6.0"

src_prepare() {
	mkdir libs
}

src_install() {
	java-pkg_dojar jars/*.jar
	use source && java-pkg_dosrc src/main/java/
}
