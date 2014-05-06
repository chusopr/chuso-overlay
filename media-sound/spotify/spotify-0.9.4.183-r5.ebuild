# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/spotify/spotify-0.9.4.183-r5.ebuild,v 1.2 2014/01/28 04:24:21 prometheanfire Exp $

EAPI=5

AV_VERSION="0.8.11"
AV_IUSE="+3dnow +3dnowext +bzip2 cpudetection custom-cflags debug +hardcoded-tables +mmx +mmxext pic +ssse3 threads +zlib"
CPU_FEATURES="3dnow:amd3dnow 3dnowext:amd3dnowext avx mmx mmxext:mmx2 neon ssse3"

use !external-libav && AV_ECLASSES="flag-o-matic multilib toolchain-funcs"

inherit eutils fdo-mime gnome2-utils pax-utils unpacker ${AV_ECLASSES}

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"
MY_PV="${PV}.g644e24e.428-1"
MY_P="${PN}-client_${MY_PV}"
SRC_BASE="http://repository.spotify.com/pool/non-free/${PN:0:1}/${PN}/"
SRC_URI="
	x86?   ( ${SRC_BASE}${MY_P}_i386.deb )
	amd64? ( ${SRC_BASE}${MY_P}_amd64.deb )
	!external-libav? ( http://libav.org/releases/libav-${AV_VERSION}.tar.gz )
	"
LICENSE="Spotify !external-libav? ( LGPL-2.1 )"
SLOT="0"
#amd64 and x86 keywords removed due to security concerns, see bug 474010
KEYWORDS="~amd64 ~x86"

IUSE="external-libav gnome pax_kernel pulseaudio ${AV_IUSE}"

for i in ${CPU_FEATURES}; do
	IUSE+=" ${i%:*}"
done

RESTRICT="mirror strip"

COMMON_DEPEND=" !external-libav? (
		bzip2? ( app-arch/bzip2 )
		zlib? ( sys-libs/zlib )
	)"

DEPEND="${COMMON_DEPEND}
		!external-libav? ( mmx? ( dev-lang/yasm ) )"

RDEPEND="${COMMON_DEPEND}
		x11-libs/libxcb
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXext
		x11-libs/libXinerama
		x11-libs/libXdmcp
		x11-libs/libXScrnSaver
		x11-libs/libXrandr
		x11-libs/libXrender
		dev-qt/qtcore:4[qt3support]
		dev-qt/qtdbus:4
		dev-qt/qtgui:4[qt3support]
		dev-qt/qtwebkit:4
		x11-misc/xdg-utils
		media-libs/alsa-lib
		media-libs/fontconfig
		media-libs/freetype
		dev-libs/openssl:0
		dev-libs/glib:2
		dev-libs/libgcrypt:0/11
		media-libs/libpng:1.2
		dev-db/sqlite:3
		sys-libs/zlib
		app-arch/bzip2
		sys-apps/dbus
		sys-apps/util-linux
		dev-libs/expat
		>=dev-libs/nspr-4.9
		gnome-base/gconf:2
		x11-libs/gtk+:2
		dev-libs/nss
		dev-libs/glib:2
		net-print/cups
		virtual/udev
		pulseaudio? ( >=media-sound/pulseaudio-0.9.21 )
		gnome? ( gnome-extra/gnome-integration-spotify )
		external-libav? ( media-video/libav:0/0.8 )"

S=${WORKDIR}

QA_PREBUILT="/opt/spotify/spotify-client/spotify
			/opt/spotify/spotify-client/Data/SpotifyHelper
			/opt/spotify/spotify-client/Data/libcef.so"

src_prepare() {
	# link against openssl-1.0.0 as it crashes with 0.9.8
	sed -i \
		-e 's/\(lib\(ssl\|crypto\).so\).0.9.8/\1.1.0.0/g' \
		opt/spotify/spotify-client/spotify || die "sed failed"
	sed -i \
		-e 's/\(lib\(ssl\|crypto\).so\).0.9.8/\1.1.0.0/g' \
		opt/spotify/spotify-client/Data/SpotifyHelper || die "sed failed"
	# different NSPR / NSS library names for some reason
	sed -i \
		-e 's/\(lib\(plc4\|nspr4\).so\).9\(.\)/\1.0d\3\3/g' \
		opt/spotify/spotify-client/Data/SpotifyHelper || die "sed failed"
	sed -i \
		-e 's/\(lib\(nss3\|nssutil3\|smime3\).so\).1d/\1\x00\x00\x00/g' \
		-e 's/\(lib\(plc4\|nspr4\).so\).0d\(.\)/\1\x00\x00\3\3/g' \
		opt/spotify/spotify-client/Data/libcef.so || die "sed failed"
	# Fix desktop entry to launch spotify-dbus.py for GNOME integration
	if use gnome ; then
	sed -i \
		-e 's/spotify \%U/spotify-dbus.py \%U/g' \
		opt/spotify/spotify-client/spotify.desktop || die "sed failed"
	fi
	#and fix other stuff in the desktop file as well
	sed -i \
		-e 's/x-scheme-handler\/spotify$/x-scheme-handler\/spotify\;/g' \
		-e 's/AudioVideo$/AudioVideo\;/g' \
		opt/spotify/spotify-client/spotify.desktop || die "sed failed"
}

src_configure() {
	use !external-libav &&
	{
		local uses i

		uses="debug zlib"
		use debug || myconf+=" --disable-debug"
		use zlib || myconf+=" --disable-zlib"
		use bzip2 || myconf+=" --disable-bzlib"
		use custom-cflags && myconf+=" --disable-optimizations"
		use cpudetection && myconf+=" --enable-runtime-cpudetect"

		# Threads; we only support pthread for now but ffmpeg supports more
		use threads && myconf+=" --enable-pthreads"

		# CPU features
		for i in ${CPU_FEATURES}; do
			use ${i%:*} || myconf+=" --disable-${i#*:}"
		done

		# pass the right -mfpu as extra
		use neon && myconf+=" --extra-cflags=-mfpu=neon"

		# disable mmx accelerated code if PIC is required
		# as the provided asm decidedly is not PIC for x86.
		if use pic && use x86 ; then
			myconf+=" --disable-mmx --disable-mmx2"
		fi

		# Option to force building pic
		use pic && myconf+=" --enable-pic"

		# Try to get cpu type based on CFLAGS.
		# Bug #172723
		# We need to do this so that features of that CPU will be better used
		# If they contain an unknown CPU it will not hurt since ffmpeg's configure
		# will just ignore it.
		for i in $(get-flag march) $(get-flag mcpu) $(get-flag mtune) ; do
			[ "${i}" = "native" ] && i="host" # bug #273421
			[[ ${i} = *-sse3 ]] && i="${i%-sse3}" # bug 283968
			myconf+=" --cpu=${i}"
			break
		done

		# Misc stuff
		use hardcoded-tables && myconf+=" --enable-hardcoded-tables"

		# Specific workarounds for too-few-registers arch...
		if [[ $(tc-arch) == "x86" ]]; then
			filter-flags -fforce-addr -momit-leaf-frame-pointer
			append-flags -fomit-frame-pointer
			is-flag -O? || append-flags -O2
			if use debug; then
				# no need to warn about debug if not using debug flag
				ewarn ""
				ewarn "Debug information will be almost useless as the frame pointer is omitted."
				ewarn "This makes debugging harder, so crashes that has no fixed behavior are"
				ewarn "difficult to fix. Please have that in mind."
				ewarn ""
			fi
		fi

		cd "${S}/libav-${AV_VERSION}"
		./configure \
			--prefix="${EPREFIX}"/opt/spotify/spotify-client/Data \
			--libdir="${EPREFIX}"/opt/spotify/spotify-client/Data \
			--shlibdir="${EPREFIX}"/opt/spotify/spotify-client/Data \
			--mandir="${EPREFIX}"/opt/spotify/spotify-client/Data \
			--enable-shared \
			--cc="$(tc-getCC)" \
			--ar="$(tc-getAR)" \
			--disable-everything \
			--disable-static \
			--disable-ffmpeg \
			--disable-avconv \
			--disable-avdevice \
			--disable-avplay \
			--disable-avprobe \
			--disable-avserver \
			--disable-network \
			--disable-avfilter \
			--disable-swscale \
			--disable-doc \
			--enable-demuxer=aac \
			--enable-demuxer=mp3 \
			--enable-demuxer=mov \
			--enable-decoder=aac \
			--enable-decoder=mp3 \
			--enable-decoder=mp3float \
			--enable-decoder=mp3on4 \
			--enable-decoder=mp3on4float \
			--enable-parser=aac \
			--enable-parser=mpegaudio \
			--enable-protocol=file \
			${myconf} || die

		MAKEOPTS+=" V=1"
	}
}

src_compile() {
	use !external-libav && {
		cd "${S}/libav-${AV_VERSION}"
		emake || die
	}
}

src_install() {
	dodoc opt/spotify/spotify-client/changelog
	dodoc usr/share/doc/spotify-client/changelog.Debian.gz
	dodoc usr/share/doc/spotify-client/copyright

	insinto /usr/share/pixmaps
	doins opt/spotify/spotify-client/Icons/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify/spotify-client
	insinto ${SPOTIFY_HOME}
	doins -r opt/spotify/spotify-client/*
	fperms +x ${SPOTIFY_HOME}/spotify
	fperms +x ${SPOTIFY_HOME}/Data/SpotifyHelper

	dodir /usr/bin
	cat <<-EOF >"${D}"/usr/bin/spotify
		#! /bin/sh
		LD_PRELOAD="\${LD_PRELOAD} ${SPOTIFY_HOME}/libnspr4.so.9 ${SPOTIFY_HOME}/libplc4.so.9"
		LD_LIBRARY_PATH="${SPOTIFY_HOME}/Data/"
		export LD_PRELOAD
		export LD_LIBRARY_PATH
		exec ${SPOTIFY_HOME}/spotify "\$@"
	EOF
	fperms +x /usr/bin/spotify

	# revdep-rebuild produces a false positive because of symbol versioning
	dodir /etc/revdep-rebuild
	cat <<-EOF >"${D}"/etc/revdep-rebuild/10${PN}
		SEARCH_DIRS_MASK="${SPOTIFY_HOME}"
	EOF

	for size in 16 22 24 32 48 64 128 256; do
		newicon -s ${size} "${S}${SPOTIFY_HOME}/Icons/spotify-linux-${size}.png" \
			"spotify-client.png"
	done
	domenu "${S}${SPOTIFY_HOME}/spotify.desktop"

	if use pax_kernel; then
		#create the headers, reset them to default, then paxmark -m them
		pax-mark C "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark C "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/Data/SpotifyHelper" || die
		eqawarn "You have set USE=pax_kernel meaning that you intendto run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi

	#hack to fix the nspr linking in spotify
	dosym /usr/lib/libnspr4.so "${SPOTIFY_HOME}/libnspr4.so.9"
	dosym /usr/lib/libplc4.so "${SPOTIFY_HOME}/libplc4.so.9"
	#TODO fix for x86
	dosym /usr/lib/libudev.so "${SPOTIFY_HOME}/Data/libudev.so.0"

	use !external-libav && {
		cd "${S}/libav-${AV_VERSION}"
		emake DESTDIR="${D}" install || die
		rm -fr "${D}/opt/spotify/spotify-client/Data/include" "${D}/opt/spotify/spotify-client/Data/pkgconfig"
	}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
	ewarn
	ewarn "you need to use the ld.bfd linker with openssl"
}

pkg_postrm() {
	gnome2_icon_cache_update
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}
