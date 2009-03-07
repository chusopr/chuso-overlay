# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://nel.svn.sourceforge.net/svnroot/nel/trunk/nel@${PV}"

inherit eutils games subversion

DESCRIPTION="Platform for the next-generation of Persistent Worlds under GNU General Public License"
HOMEPAGE="http://www.opennel.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc gtk nosound openal opengl"

RESTRICT="mirror"

DEPEND="dev-libs/libxml2
		media-libs/freetype
		media-libs/jpeg
		x11-proto/xf86vidmodeproto
		gtk? ( =x11-libs/gtk+-2* )
		openal? ( media-libs/freealut )
		opengl? ( virtual/opengl )"

S=${S}
src_compile() {
	mkdir cmake
	cd cmake
	opts="-DCMAKE_INSTALL_PREFIX=${D}/usr"
	use doc		&& opts="${opts} -DBUILD_DOCUMENTATION:BOOL=ON" ||
				   opts="${opts} -DBUILD_DOCUMENTATION:BOOL=OFF"
	use gtk		&& opts="${opts} -DWITH_GTK:BOOL=ON" ||
				   opts="${opts} -DWITH_GTK:BOOL=OFF"
	use nosound	&& opts="${opts} -DWITH_SOUND:BOOL=OFF" ||
				   opts="${opts} -DWITH_SOUND:BOOL=ON"
	use openal	&& opts="${opts} -DWITH_DRIVER_OPENAL:BOOL=ON" ||
				   opts="${opts} -DWITH_DRIVER_OPENAL:BOOL=OFF"
	use opengl	&& opts="${opts} -DWITH_3D:BOOL=ON -DWITH_DRIVER_OPENGL:BOOL=ON" ||
				   opts="${opts} -DWITH_3D:BOOL=OFF -DWITH_DRIVER_OPENGL:BOOL=OFF"
	cmake -G "Unix Makefiles" ${opts} .. || die "Configure failed"
	emake || die "emake failed"
}

src_install() {
	cd cmake
	einstall
	prepgamesdirs
}
