# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_PN=${PN/-bin/}
MY_PV=${PV/_/-}
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="Blood remake"
HOMEPAGE="http://www.transfusion-game.com/"
SRC_URI="mirror://sourceforge/blood/${MY_P}.zip
	mirror://sourceforge/blood/${MY_P}_patch.zip
	mirror://gentoo/${MY_PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""
RESTRICT="strip mirror"

RDEPEND="sys-libs/glibc"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${MY_P}

dir=${GAMES_PREFIX_OPT}/${MY_PN}
Ddir=${D}/${dir}

src_unpack() {
	unpack "${MY_PN}-${MY_PV}.zip"
	cd "${S}"
	unpack "${MY_PN}-${MY_PV}_patch.zip"
}

src_install() {
	dodir "${GAMES_PREFIX_OPT}/${MY_PN}"
	cp -R basetf "${MY_PN}-glx" "${D}/${GAMES_PREFIX_OPT}/${MY_PN}" || die "cp failed"

	dodoc doc/*.txt
	dohtml doc/*.html

	doicon "${DISTDIR}/${MY_PN}.png"
	games_make_wrapper ${MY_PN} ./${MY_PN}-glx "${GAMES_PREFIX_OPT}/${MY_PN}"
	make_desktop_entry ${MY_PN} "Transfusion" ${MY_PN}

	chmod ug+x "${D}/${GAMES_PREFIX_OPT}/${MY_PN}/${MY_PN}-glx"
	prepgamesdirs
}
