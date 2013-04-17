# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylast/pylast-0.5.11.ebuild,v 1.2 2012/05/29 17:11:23 jdhore Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="GNOME desktop application for downloading and playing audio files from the grooveshark.com service"
HOMEPAGE="http://${PN}.bultux.org"
SRC_URI="https://bitbucket.org/vkolev/${PN}/get/${PN}_${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk:2
		dev-python/configobj
		dev-python/pygobject:2
		dev-python/gst-python:0.10
		dev-python/pycurl
		dev-python/notify-python
		dev-python/pyxdg
		dev-python/pylast"
RDEPEND="${DEPEND}"
S="${WORKDIR}/vkolev-${PN}-1ad5361b56d9"
