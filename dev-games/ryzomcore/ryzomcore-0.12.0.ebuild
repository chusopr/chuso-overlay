# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

EHG_REPO_URI="https://bitbucket.org/ryzom/ryzomcore"
EHG_REVISION="ryzomcore/v${PV}"

inherit cmake-utils games mercurial

DESCRIPTION="Platform for the next-generation of Persistent Worlds under GNU General Public License"
HOMEPAGE="http://www.opennel.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="log coverage pch static external gtk debug stlport dashboard network
3d pacs georges ligo logic audio opengl cegui samples tests nelns login-system
ryzom snowballs openal fmod tools gles client server squish doc"

RESTRICT="mirror"

RDEPEND="dev-libs/libxml2
		sys-libs/zlib
		media-libs/libpng
		virtual/jpeg
		x11-libs/libX11
		x11-libs/libXext
		x11-misc/xdg-utils
		nelns? (
			net-misc/curl
			dev-db/mysql
		)
		ryzom? (
			net-misc/curl
			net-libs/libwww
			dev-lang/lua
			dev-cpp/luabind
			server? ( dev-db/mysql )
		)
		audio? (
			media-libs/libogg
			media-libs/libvorbis
		)
		3d? (
			dev-util/cpptest
			media-libs/freetype
			opengl? (
				x11-libs/libXxf86vm
				x11-libs/libICE
			)
		)
		tests? ( dev-util/cpptest )
		tools? ( squish? ( media-libs/squish ) )
		client? ( media-libs/freetype )
		virtual/jpeg
		opengl? ( virtual/opengl )
		openal? ( media-libs/openal )
		gtk? ( x11-libs/gtk+ )
		stlport? ( dev-libs/STLport )
		cegui? ( dev-games/cegui )
		fmod? ( media-libs/fmod )"

DEPEND="${RDEPEND}
		dev-util/boost-build"

pkg_pretend() {
	use nelns && use !network && die "nelns flag requires network flag"
	use audio && (use !3d || use !ligo || use !georges) && die "audio flag requires 3d, georges and ligo flags"
	use client && use !network && die "client flag requires network flag"
	use server && use !network && die "server flag requires network flag"
	use ryzom && use client && use !audio && die "ryzom && client flags require audio and ryzom flags"
	use openal && use !audio && die "openal flag requires audio flag"
	use fmod && use !audio && die "fmod flag requires audio flag"
	use gles && use !opengl && die "gles flag requires opengl flag"
	use squish && use !tests && die "squish flag requires tests flag"
}

src_prepare() {
	#0# epatch "${FILESDIR}/std_namespace.patch" || die
	#epatch "${FILESDIR}/freetype_path.patch" || die
	#0# epatch "${FILESDIR}/${P}-scope.patch" || die
	#0# epatch "${FILESDIR}/${P}-c11.patch" || die
	epatch "${FILESDIR}/operators_exceptions.patch" || die
	sed -i 's%/etc/alternatives/x-www-browser%xdg-open%' code/nel/src/misc/common.cpp || die
	#0# sed -i 's% -ansi%%' code/CMakeModules/nel.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	S="${WORKDIR}/${P}/code"
	local mycmakeargs=(
		$(cmake-utils_use_with log LOGGING)
		$(cmake-utils_use_with coverage COVERAGE)
		$(cmake-utils_use_with pch PCH)
		$(cmake-utils_use_with static STATIC)
		$(cmake-utils_use_with static STATIC_DRIVERS)
		$(cmake-utils_use_with external EXTERNAL)
		$(cmake-utils_use_with gtk GTK)
		$(cmake-utils_use_with debug SYMBOLS)
		$(cmake-utils_use_with debug DEBUG)
		$(cmake-utils_use_with stlport STLPORT)
		$(cmake-utils_use_build dashboard DASHBOARD)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_with network NET)
		$(cmake-utils_use_with 3d 3D)
		$(cmake-utils_use_with pacs PACS)
		$(cmake-utils_use_with georges GEORGES)
		$(cmake-utils_use_with ligo LIGO)
		$(cmake-utils_use_with logic LOGIC)
		$(cmake-utils_use_with audio SOUND)
		$(cmake-utils_use_with opengl DRIVER_OPENGL)
		$(cmake-utils_use_with cegui NEL_CEGUI)
		$(cmake-utils_use_with samples NEL_SAMPLES)
		$(cmake-utils_use_with tests NEL_TESTS)
		$(cmake-utils_use_with nelns NELNS)
		$(cmake-utils_use_with ryzom RYZOM)
		$(cmake-utils_use_with snowballs SNOWBALLS)
		$(cmake-utils_use_with openal DRIVER_OPENAL)
		$(cmake-utils_use_with fmod DRIVER_FMOD)
		$(cmake-utils_use_with tools NEL_TOOLS)
		$(cmake-utils_use_with gles DRIVER_OPENGLES)
		-DWITH_GUI:BOOL=OFF
		-DWITH_QT:BOOL=OFF
		-DWITH_NEL:BOOL=ON
		-DWITH_INSTALL_LIBRARIES:BOOL=ON
		$(
			( use debug || ( use ryzom && use client ) ) &&
				echo -DFINAL_VERSION:BOOL=OFF ||
				echo -DFINAL_VERSION:BOOL=ON
		)
	)

	use ryzom &&
		mycmakeargs+=(
			$(cmake-utils_use_with tools RYZOM_TOOLS)
			$(cmake-utils_use_with audio RYZOM_SOUND)
		)

	use nelns &&
		mycmakeargs+=(
			$(cmake-utils_use_with server NELNS_SERVER)
			$(cmake-utils_use_with login-system NELNS_LOGIN_SYSTEM)
		)
	use static &&
		mycmakeargs+=(
			$(cmake-utils_use_with static-external STATIC_EXTERNAL)
		)

	use client &&
		mycmakeargs+=(
			$(cmake-utils_use_with ryzom RYZOM_CLIENT)
			$(cmake-utils_use_with snowballs SNOWBALLS_CLIENT)
		)

	use 3d || use client &&
		mycmakeargs+=(
			-DFREETYPE_INCLUDE_DIRS=$(freetype-config --prefix)/include/freetype2
			$(cmake-utils_use_with ryzom RYZOM_CLIENT)
			$(cmake-utils_use_with snowballs SNOWBALLS_CLIENT)
		)

	use server &&
		mycmakeargs+=(
			$(cmake-utils_use_with ryzom RYZOM_SERVER)
			$(cmake-utils_use_with snowballs SNOWBALLS_SERVER)
		)

	cmake-utils_src_configure
	S="${WORKDIR}/${P}_build"
}

src_install() {
	emake DESTDIR="${D}" install || die
	echo "LDPATH=\"/usr/lib/nel\"" >> "${T}/99${PN}"
	doenvd "${T}/99${PN}"
}
