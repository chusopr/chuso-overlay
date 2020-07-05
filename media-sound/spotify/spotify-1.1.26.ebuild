# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FF_VERSION="3.4.6"

FF_ECLASSES="eutils flag-o-matic toolchain-funcs"
inherit desktop pax-utils unpacker xdg ${FF_ECLASSES}

DESCRIPTION="Spotify is a social music platform"
HOMEPAGE="https://www.spotify.com/ch-de/download/previews/"
SRC_BASE="http://repository.spotify.com/pool/non-free/s/${PN}-client/"
BUILD_ID_AMD64="501.gbe11e53b-15"
SRC_URI="
	${SRC_BASE}${PN}-client_${PV}.${BUILD_ID_AMD64}_amd64.deb
	!external-ffmpeg? ( http://ffmpeg.org/releases/ffmpeg-${FF_VERSION}.tar.bz2 )
	"
LICENSE="
	Spotify
	!external-ffmpeg? (
		!gpl? ( LGPL-2.1 )
		gpl? ( GPL-2 )
		amr? (
			gpl? ( GPL-3 )
			!gpl? ( LGPL-3 )
		)
		gmp? (
			gpl? ( GPL-3 )
			!gpl? ( LGPL-3 )
		)
	)
"
SLOT="0"
KEYWORDS="~amd64"

FFMPEG_FLAG_MAP=(
		+bzip2:bzlib cpudetection:runtime-cpudetect debug gcrypt gmp
		+gpl +hardcoded-tables lzma
		+zlib
		# decoders
		amr:libopencore-amrwb amr:libopencore-amrnb
		gme:libgme gsm:libgsm
		modplug:libmodplug opus:libopus libilbc
		speex:libspeex vorbis:libvorbis
		# libswresample options
		libsoxr
		# Threads; we only support pthread for now but ffmpeg supports more
		+threads:pthreads
)

FFMPEG_IUSE="
	pic
	external-ffmpeg
	${FFMPEG_FLAG_MAP[@]%:*}
"

IUSE="libnotify libressl systray pax_kernel ${FFMPEG_IUSE}"

X86_CPU_FEATURES_RAW=( 3dnow:amd3dnow 3dnowext:amd3dnowext aes:aesni avx:avx avx2:avx2 fma3:fma3 fma4:fma4 mmx:mmx mmxext:mmxext sse:sse sse2:sse2 sse3:sse3 ssse3:ssse3 sse4_1:sse4 sse4_2:sse42 xop:xop )
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma4? ( cpu_flags_x86_avx )
	cpu_flags_x86_fma3? ( cpu_flags_x86_avx )
	cpu_flags_x86_xop?  ( cpu_flags_x86_avx )
	cpu_flags_x86_avx?  ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_aes? ( cpu_flags_x86_sse4_2 )
	cpu_flags_x86_sse4_2?  ( cpu_flags_x86_sse4_1 )
	cpu_flags_x86_sse4_1?  ( cpu_flags_x86_ssse3 )
	cpu_flags_x86_ssse3?  ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse3?  ( cpu_flags_x86_sse2 )
	cpu_flags_x86_sse2?  ( cpu_flags_x86_sse )
	cpu_flags_x86_sse?  ( cpu_flags_x86_mmxext )
	cpu_flags_x86_mmxext?  ( cpu_flags_x86_mmx )
	cpu_flags_x86_3dnowext?  ( cpu_flags_x86_3dnow )
	cpu_flags_x86_3dnow?  ( cpu_flags_x86_mmx )"

CPU_FEATURES_MAP=(
	${X86_CPU_FEATURES[@]}
)
IUSE="${IUSE}
	${CPU_FEATURES_MAP[@]%:*}"

RESTRICT="mirror strip"

FF_RDEPEND="
	amr? ( >=media-libs/opencore-amr-0.1.3-r1 )
	bzip2? ( >=app-arch/bzip2-1.0.6-r4 )
	gcrypt? ( >=dev-libs/libgcrypt-1.6:0= )
	gme? ( >=media-libs/game-music-emu-0.6.0 )
	gmp? ( >=dev-libs/gmp-6:0= )
	gsm? ( >=media-sound/gsm-1.0.13-r1 )
	libilbc? ( >=media-libs/libilbc-2 )
	libsoxr? ( >=media-libs/soxr-0.1.0 )
	lzma? ( >=app-arch/xz-utils-5.0.5-r1 )
	modplug? ( >=media-libs/libmodplug-0.8.8.4-r1 )
	opus? ( >=media-libs/opus-1.0.2-r2 )
	speex? ( >=media-libs/speex-1.2_rc1-r1 )
	vorbis? (
		>=media-libs/libvorbis-1.3.3-r1
		>=media-libs/libogg-1.3.0
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1 )
"

BDEPEND=">=dev-util/patchelf-0.10"
RDEPEND="
	dev-libs/nss
	dev-python/dbus-python
	dev-python/pygobject:3
	libnotify? ( x11-libs/libnotify )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/harfbuzz
	media-libs/mesa[X(+)]
	net-misc/curl[ssl]
	net-print/cups[ssl]
	|| ( media-sound/pulseaudio media-sound/apulse )
	systray? ( gnome-extra/gnome-integration-spotify )
	x11-libs/gtk+:2
	app-accessibility/at-spi2-atk
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	external-ffmpeg? ( media-video/ffmpeg:0/55.57.57[bzip2=,debug=,gcrypt=,gmp=,gpl=,hardcoded-tables=,lzma=,zlib=,amr=,gme=,gsm=,modplug=,opus=,libilbc=,speex=,vorbis=,libsoxr=,threads=] )
	!external-ffmpeg? ( $FF_RDEPEND )
"

DEPEND="${RDEPEND}
	>=sys-devel/make-3.81
	virtual/pkgconfig
	cpu_flags_x86_mmx? ( || ( >=dev-lang/nasm-2.13 >=dev-lang/yasm-1.3 ) )
"

S=${WORKDIR}/

QA_PREBUILT="opt/spotify/spotify-client/spotify"

src_prepare() {
	# Fix desktop entry to launch spotify-dbus.py for systray integration
	if use systray ; then
		sed -i \
			-e 's/spotify \%U/spotify-dbus.py \%U/g' \
			usr/share/spotify/spotify.desktop || die "sed failed"
	fi
	default

	# Spotify links against libcurl-gnutls.so.4, which does not exist in Gentoo.
	patchelf --replace-needed libcurl-gnutls.so.4 libcurl.so.4 usr/bin/spotify \
		|| die "failed to patch libcurl library dependency"
	use external-ffmpeg || S="${WORKDIR}/ffmpeg-${FF_VERSION}"
}

src_configure() {
	use external-ffmpeg ||
	(
		local ffuse=( "${FFMPEG_FLAG_MAP[@]}" )

		use amr && myconf+=( --enable-version3 )
		use gmp && myconf+=( --enable-version3 )

		for i in "${ffuse[@]#+}" ; do
			myconf+=( $(use_enable ${i%:*} ${i#*:}) )
		done

		# CPU features
		for i in "${CPU_FEATURES_MAP[@]}" ; do
			use ${i%:*} || myconf+=( --disable-${i#*:} )
		done

		if use pic ; then
			myconf+=( --enable-pic )
		fi

		# Try to get cpu type based on CFLAGS.
		# Bug #172723
		# We need to do this so that features of that CPU will be better used
		# If they contain an unknown CPU it will not hurt since ffmpeg's configure
		# will just ignore it.
		for i in $(get-flag mcpu) $(get-flag march) ; do
			[[ ${i} = native ]] && i="host" # bug #273421
			myconf+=( --cpu=${i} )
			break
		done

		for i in \
			012v 4xm 8bps a64_multi a64_multi5 aasc agm aic alias_pix amv anm ansi apng arbc asv1 asv2 aura aura2 av1 avrn avrp avs avs2 avui ayuv bethsoftvid bfi binkvideo bintext bitpacked bmp bmv_video brender_pix c93 cavs cdgraphics cdxl cfhd cinepak clearvideo cljr cllc cmv cpia cscd cyuv daala dds dfa dirac dnxhd dpx dsicinvideo dvvideo dxa dxtory dxv escape124 escape130 exr ffv1 ffvhuff fic fits flashsv flashsv2 flic flv1 fmvc fraps frwu g2m gdv gif h261 h263 h263i h263p h264 hap hevc hnm4video hq_hqa hqx huffyuv hymt idcin idf iff_ilbm imm4 indeo2 indeo3 indeo4 indeo5 interplayvideo jpeg2000 jpegls jv kgv1 kmvc lagarith ljpeg loco lscr m101 mad magicyuv mdec mimic mjpeg mjpegb mmvideo motionpixels mpeg1video mpeg2video mpeg4 msa1 mscc msmpeg4v1 msmpeg4v2 msmpeg4v3 msrle mss1 mss2 msvideo1 mszh mts2 mvc1 mvc2 mwsc mxpeg nuv paf_video pam pbm pcx pgm pgmyuv pictor pixlet png ppm prores prosumer psd ptx qdraw qpeg qtrle r10k r210 rasc rawvideo rl2 roq rpza rscc rv10 rv20 rv30 rv40 sanm scpr screenpresso sgi sgirle sheervideo smackvideo smc smvjpeg snow sp5x speedhq srgc sunrast svg svq1 svq3 targa targa_y216 tdsc tgq tgv theora thp tiertexseqvideo tiff tmv tqi truemotion1 truemotion2 truemotion2rt tscc tscc2 txd ulti utvideo v210 v210x v308 v408 v410 vb vble vc1 vc1image vcr1 vixl vmdvideo vmnc vp3 vp4 vp5 vp6 vp6a vp6f vp7 vp8 vp9 wcmv webp wmv1 wmv2 wmv3 wmv3image wnv1 wrapped_avframe ws_vqa xan_wc3 xan_wc4 xbin xbm xface xpm xwd y41p ylc yop yuv4 zerocodec zlib zmbv \
			arib_caption ass dvb_subtitle dvb_teletext dvd_subtitle eia_608 hdmv_pgs_subtitle hdmv_text_subtitle jacosub microdvd mov_text mpl2 pjs realtext sami srt ssa stl subrip subviewer subviewer1 text ttml vplayer webvtt xsub \
			;
		do
			myconf+=( --disable-decoder=${i} )
		done

		myconf=(
			--disable-doc
			--disable-manpages
			--disable-muxers
			--disable-encoders
			--disable-devices
			--disable-protocols
			--enable-protocol=file
			--disable-network
			--disable-ffprobe
			--disable-ffserver
			--disable-avfilter
			--disable-avresample
			--disable-avdevice
			--disable-postproc
			--disable-swscale
			--disable-stripping
			--disable-libcelt
			--disable-libxcb
			--disable-xlib
			--disable-sdl2
			--disable-iconv
			--disable-alsa
			--disable-libv4l2
			--disable-libzmq
			--disable-frei0r
			--disable-nvenc
			--disable-v4l2_m2m
			"${myconf[@]}"
		)

		set -- "${S}/configure" \
			--prefix="/opt/spotify/spotify-client" \
			--libdir="/opt/spotify/spotify-client" \
			--shlibdir="/opt/spotify/spotify-client/" \
			--enable-shared \
			--cc="$(tc-getCC)" \
			--cxx="$(tc-getCXX)" \
			--ar="$(tc-getAR)" \
			--optflags="${CFLAGS}" \
			"${myconf[@]}"
		echo "${@}"
		"${@}" || die
	)
}

src_install() {
	use external-ffmpeg || {
		emake DESTDIR="${D}" install
		S=${WORKDIR}/
		cd "${S}"
	}
	gunzip usr/share/doc/spotify-client/changelog.gz || die
	dodoc usr/share/doc/spotify-client/changelog

	SPOTIFY_PKG_HOME=usr/share/spotify
	insinto /usr/share/pixmaps
	doins ${SPOTIFY_PKG_HOME}/icons/*.png

	# install in /opt/spotify
	SPOTIFY_HOME=/opt/spotify/spotify-client
	insinto ${SPOTIFY_HOME}
	doins -r ${SPOTIFY_PKG_HOME}/*
	fperms +x ${SPOTIFY_HOME}/spotify

	FF_LD_PATH=
	use external-ffmpeg || FF_LD_PATH=":/opt/spotify/spotify-client"

	dodir /usr/bin
	cat <<-EOF >"${D}"/usr/bin/spotify || die
		#! /bin/sh
		LD_LIBRARY_PATH="/usr/$(get_libdir)/apulse${FF_LD_PATH}" \\
		exec ${SPOTIFY_HOME}/spotify "\$@"
	EOF
	fperms +x /usr/bin/spotify

	local size
	for size in 16 22 24 32 48 64 128 256 512; do
		newicon -s ${size} "${S}${SPOTIFY_PKG_HOME}/icons/spotify-linux-${size}.png" \
			"spotify-client.png"
	done
	domenu "${S}${SPOTIFY_PKG_HOME}/spotify.desktop"
	if use pax_kernel; then
		#create the headers, reset them to default, then paxmark -m them
		pax-mark C "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark z "${ED}${SPOTIFY_HOME}/${PN}" || die
		pax-mark m "${ED}${SPOTIFY_HOME}/${PN}" || die
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.	To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn "If Spotify crashes after an upgrade its cache may be corrupt."
	ewarn "To remove the cache:"
	ewarn "rm -rf ~/.cache/spotify"
}
