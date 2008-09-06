# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm
DESCRIPTION="Generates IceWM menus from XDG entries"

HOMEPAGE="http://www.icewm.org/"

MY_P="${P/-xdg-menu/}"
FV="-4.fc8"
SRC_URI="mirror://fedora/../development/source/SRPMS/${MY_P}${FV}.src.rpm"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"

IUSE=""

RESTRICT="mirror"

# Build-time dependencies, such as
#    ssl? ( >=dev-libs/openssl-0.9.6b )
#    >=dev-lang/perl-5.6.1-r1
# It is advisable to use the >= syntax show above, to reflect what you
# had installed on your system when you tested the package.  Then
# other users hopefully won't be caught without the right version of
# a dependency.
DEPEND="dev-python/pyxdg"

# Run-time dependencies. Must be defined to whatever this depends on to run.
# The below is valid if the same run-time depends are required to compile.
RDEPEND="${DEPEND}
		 x11-wm/icewm"

# Source directory; the dir where the sources can be found (automatically
# unpacked) inside ${WORKDIR}.  The default value for S is ${WORKDIR}/${P}
# If you don't need to change it, leave the S= line out of the ebuild
# to keep it tidy.
S="${WORKDIR}/${P/xdg-menu/xdgmenu}"

src_install() {
	dobin icewm-xdg-menu
}
