# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools desktop flag-o-matic

MUSIC_P=SMC_Music_4.1_high
DESCRIPTION="Secret Maryo Chronicles"
HOMEPAGE="http://www.secretmaryo.org/"
SRC_URI="mirror://sourceforge/smclone/${P}.tar.bz2
	music? ( mirror://sourceforge/smclone/${MUSIC_P}.zip )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc music"

RDEPEND="<dev-games/cegui-0.7[opengl,devil]
	dev-libs/boost
	virtual/opengl
	virtual/glu
	x11-libs/libX11
	dev-libs/libpcre[unicode]
	media-libs/libpng:0
	media-libs/libsdl[X,joystick,opengl]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	music? ( app-arch/unzip )"

src_unpack() {
	unpack ${P}.tar.bz2
	if use music; then
		cd "${S}" || die
		unpack ${MUSIC_P}.zip
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-boost150.patch \
		"${FILESDIR}"/${P}-underlink.patch
	eautoreconf
}

src_install() {
	if use doc; then
		DOCS="docs/*.txt docs/*.html"
	fi
	default
	newicon data/icon/window_32.png smc.png
	make_desktop_entry ${PN} "Secret Maryo Chronicles"
	doman makefiles/unix/man/smc.6
}
