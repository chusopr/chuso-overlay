# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gkrellm-plugin

DESCRIPTION="Binary clock for GKrellM1/2"
HOMEPAGE="http://www.kagami.org/gkbinclock/"
SRC_URI="http://www.kagami.org/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PLUGIN_SO=${PN}.2.so

src_compile() {
	emake ${PN}.2.so || die "emake failed"
}
