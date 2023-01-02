# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN/-bin/}_${PV}"

inherit systemd

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="https://joinmobilizon.org"
SRC_URI="https://packages.joinmobilizon.org/${PV}/${MY_P}_${ARCH}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~arm"

RDEPEND="acct-user/mobilizon
		dev-db/postgis
		media-gfx/gifsicle
		media-gfx/imagemagick
		media-gfx/jpegoptim
		media-gfx/optipng
		media-gfx/pngquant
		media-libs/libwebp
		sys-apps/file
		virtual/httpd-basic"

S="${WORKDIR}"

src_install() {
	systemd_newunit mobilizon/support/systemd/mobilizon-release.service mobilizon.service
	newinitd "${FILESDIR}/mobilizon.initd" mobilizon
	dodoc -r mobilizon/support
	rm -fr mobilizon/support || die
	insinto /opt
	doins -r mobilizon
	keepdir /var/lib/mobilizon/uploads /var/lib/mobilizon/uploads/exports/csv /var/lib/mobilizon/data
	fowners -R mobilizon:mobilizon /var/lib/mobilizon/uploads /var/lib/mobilizon/uploads/exports/csv /var/lib/mobilizon/data
	fperms 0755 \
		/opt/mobilizon/bin/* \
		/opt/mobilizon/erts-*/bin/* \
		/opt/mobilizon/lib/*/priv/{bin,lib}/* \
		/opt/mobilizon/lib/fast_html-2.0.5/priv/fasthtml_worker \
		/opt/mobilizon/lib/argon2_elixir-3.0.0/priv/argon2_nif.so \
		/opt/mobilizon/lib/inets-8.1/priv/bin/runcgi.sh \
		/opt/mobilizon/lib/eblurhash-1.2.2/priv/blurhash \
		/opt/mobilizon/releases/3.0.1/iex \
		/opt/mobilizon/releases/3.0.1/elixir
}

pkg_postinst() {
	einfo "Please check https://docs.joinmobilizon.org/administration/install/release/#configuration for the configuration instructions"
}
