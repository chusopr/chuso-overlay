# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WS_PV="21.11.5.1-1"
BRAND_PV="21.11-27"

case "${ARCH}" in
	"amd64")
		ARCH_REPO="CODE-ubuntu1804"
		MY_PV="${PV}-1_"
		;;
	"arm64")
		ARCH_REPO="CODE-arm64-ubuntu1804"
		MY_PV="${PV}-1_linux-5.4-"
		;;
esac

inherit fcaps font systemd unpacker

DESCRIPTION="Collabora Online Development Edition"
HOMEPAGE="https://www.collaboraoffice.com/code/"

LANGUAGES="ar as ast bg bn:bn-in bn-IN:bn-in br ca ca-valencia cs cy da de el en-GB:en-gb en:en-us en-US:en-us es et eu fi fr ga gd gl gu he hi hr hu id is it ja km kn ko lt lv ml mr nb nl nn oc or pa:pa-in pl pt pt-BR:pt-br pt-PT:pt ro ru sk sl sr sr-Latn:sr-latn sv ta te tr uk vi zh-CN:zh-cn zh-TW:zh-tw"
LANGUAGES_DICT="ar bg br ca cs da de el en es et fr gd gl gu he hi hr hu id is it ko lt lv nl no oc pl pt:pt-pt pt-BR:pt-br pt-PT:pt-pt ro ru sk sl sr sv te tr uk vi"

SRC_URI="
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/coolwsd_${WS_PV}_${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-calc_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-core_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-graphicfilter_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-images_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-impress_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-ooofonts_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-writer_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraoffice-ure_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraoffice_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-draw_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-extension-pdf-import_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-ooolinguistic_${MY_PV}${ARCH}.deb
	https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-math_${MY_PV}${ARCH}.deb
	!bindist? ( https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/code-brand_${BRAND_PV}_all.deb )
"
LICENSE="MPL-2.0 !bindist? ( Collabora )"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="bindist"
RESTRICT="strip"

for l in ${LANGUAGES}; do
	SRC_URI+=" l10n_${l%:*}? ( https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraofficebasis-${l#*:}_${MY_PV}${ARCH}.deb )"
	IUSE+=" l10n_${l%:*}"
done
for l in ${LANGUAGES_DICT}; do
	SRC_URI+=" l10n_${l%:*}? ( https://www.collaboraoffice.com/repos/CollaboraOnline/${ARCH_REPO}/collaboraoffice-dict-${l#*:}_${MY_PV}${ARCH}.deb )"
	IUSE+=" l10n_${l%:*}"
done

RDEPEND="
	acct-user/cool
	app-arch/cpio
	dev-libs/expat
	>=dev-libs/openssl-1.1.0
	media-libs/fontconfig
	media-libs/libpng
	net-misc/openssh
	sys-devel/gcc
	sys-libs/glibc
	sys-libs/libcap
	sys-libs/pam
	sys-libs/zlib
"

FILECAPS=(
	cap_fowner,cap_chown,cap_mknod,cap_sys_chroot=ep usr/bin/coolforkit --
	"cap_sys_admin=ep" usr/bin/coolmount
)

S="${WORKDIR}"

src_install() {
	docinto examples
	newdoc etc/apache2/conf-available/coolwsd.conf apache.conf
	newdoc etc/nginx/snippets/coolwsd.conf nginx.conf

	keepdir /opt/cool/child-roots /var/log/coolwsd

	mv usr/share/doc/coolwsd "usr/share/doc/${P}" || die

	doins -r opt usr
	insinto /etc
	doins -r etc/coolwsd

	fowners cool:cool /etc/coolwsd/coolwsd.xml /opt/cool/child-roots /var/log/coolwsd
	fperms 640 /etc/coolwsd/coolwsd.xml
	fperms 750 /opt/cool/child-roots /var/log/coolwsd

	chmod 755 "${ED}/usr/bin"/* || die

	systemd_dounit lib/systemd/system/coolwsd.service
	newinitd "${FILESDIR}/coolwsd.initd" coolwsd
}

pkg_postinst() {
	fcaps_pkg_postinst

	einfo "On new installs, you must generate the proof keys:"
	einfo "	coolwsd-generate-proof-key"
	einfo "And after every install of upgrade, you are advised to update the system template:"
	einfo "	coolwsd-systemplate-setup /opt/cool/systemplate /opt/collaboraoffice"
	einfo "Alternatively, you can run the config function of this package:"
	einfo "	emerge --config =${CATEGORY}/${PN}-${PVR}"
}

pkg_config() {
	coolwsd-systemplate-setup /opt/cool/systemplate /opt/collaboraoffice
	test -f /opt/cool/systemplate/etc/timezone || timedatectl show -p Timezone | cut -d = -f 2 > /opt/cool/systemplate/etc/timezone
	coolwsd-generate-proof-key
}
