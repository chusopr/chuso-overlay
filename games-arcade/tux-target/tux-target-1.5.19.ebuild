# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit games cmake-utils

MY_PN="${PN}-master"
DESCRIPTION="a Monkey Target clone (six mini-game from Super Monkey Ball)"
HOMEPAGE="http://www.mtp-target.org/"
SRC_URI="https://github.com/ryzom/${PN}/archive/master.zip
	http://www.lua.org/ftp/lua-5.0.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/lua
		dev-games/ode
		dev-games/opennel[3d,audio,network]"

# to confirm
DEPEND="dev-libs/libxml2
		dev-games/opennel
		dev-lang/lua
		net-misc/curl
		!games-arcade/mtp-target-bin"
#RDEPEND="dev-libs/STLport
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

#src_prepare() {
#	cd "${S}"
	#sed	-e 's:^FMOD_LDFLAGS .*$:FMOD_LDFLAGS   =:' \
	#	-e 's:^FMOD_CXXFLAGS .*$:FMOD_CXXFLAGS  =:' \
	#	-e 's:^CXXFLAGS_Linux .*:CXXFLAGS_Linux = -I/usr/include/libxml2:' \
	#	-e 's:$(EXT)/inst/:usr/:g' -i Variables.mk ||
	#	die "sed failed"
	#epatch "${FILESDIR}/${P}_remove_dumptags.patch"
#}

src_prepare() {
	epatch "${FILESDIR}/compile_options.patch" || die
	epatch "${FILESDIR}/compile_errors.patch" || die
	# We are hardlinking this
	sed -i "s/^\s*FIND_PACKAGE(Lua50 REQUIRED)$//" CMakeLists.txt || die
	# Fix paths
	sed -i "s%RUNTIME DESTINATION games%&/bin%" {client,server}/src/CMakeLists.txt &&
	sed -i "s%DESTINATION etc%DESTINATION /etc%" client/CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DNL_ETC_PREFIX:PATH=/etc
	)
	cmake-utils_src_configure
	# CMake seems to be missing zlib. Also, hardlink the lua version we are going to compile
	sed -i "s%-lxml2%& -lz -L../../../lua-5.0.3/lib -llua -llualib%" "${BUILD_DIR}/client/src/CMakeFiles/tux-target.dir/link.txt" || die
	sed -i "s%-lxml2%& -L../../../lua-5.0.3/lib -llua -llualib%" "${BUILD_DIR}/server/src/CMakeFiles/tux-target-srv.dir/link.txt" || die
}

src_compile() {
	cd ../lua-5.0.3 && make || die
	cd "${S}" && cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}

#src_compile() {
#	emake update || die "emake update failed"
#	emake || die "emake failed"
#}

#src_install() {
#	dodir "${GAMES_PREFIX_OPT}/${PN}"
#	cp -R data "${D}/${GAMES_PREFIX_OPT}/${PN}/data"
#	insinto "${GAMES_PREFIX_OPT}/${PN}/client"
#	doins client/src/client client/mtp_target_default.cfg
#	games_make_wrapper ${PN}-client ./client "${GAMES_PREFIX_OPT}/${PN}/client" ../lib
#	cd "${D}/${GAMES_PREFIX_OPT}"/${PN}
#	cp client/mtp_target{_default,}.cfg || die "client cfg"
#	prepgamesdirs
#	dogamesbin "${GAMES_PREFIX_OPT}/${PN}/client/client"
#}

#src_install() {
	#rm -f {client,server}/launch.sh

	#dodir "${GAMES_PREFIX_OPT}/${PN}"
	#cp -pPR "${S}/"* "${D}/${GAMES_PREFIX_OPT}"/${PN}/

	#games_make_wrapper ${PN}-client ./client "${GAMES_PREFIX_OPT}/${PN}/client" ../lib
	#games_make_wrapper ${PN}-server ./mtp_target_service "${GAMES_PREFIX_OPT}/${PN}/server" ../lib

	#dosym /usr/lib/liblualib.so "${GAMES_PREFIX_OPT}"/${PN}/lib/liblualib50.so.5.0
	#dosym /usr/lib/liblua.so "${GAMES_PREFIX_OPT}"/${PN}/lib/liblua50.so.5.0
	#dosym /usr/lib/libcurl.so "${GAMES_PREFIX_OPT}"/${PN}/lib/libcurl.so.2

	#prepgamesdirs
	#cd "${D}/${GAMES_PREFIX_OPT}"/${PN}
	#cp client/mtp_target{_default,}.cfg || die "client cfg"
	#cp server/mtp_target_service{_default,}.cfg || die "server cfg"
	#chown ${GAMES_USER}:${GAMES_GROUP} client/mtp_target.cfg server/mtp_target_service.cfg
	#chmod 660 client/mtp_target.cfg server/mtp_target_service.cfg
