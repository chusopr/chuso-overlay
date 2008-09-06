# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm

DESCRIPTION="Delphi clone. Pascal IDE"
HOMEPAGE="http://www.borland.com/kylix"
	#einfo "http://ussvs-bes1.borland.com/WebDownload/outcome_pages/k3ent_verify_email_kdown.html"
SRC_URI="http://download.borlandforum.com/kylix/Kylix3Trial/kylix3_trial.tar.gz
		 ftp://ftpd.borland.com/download/kylix/k3/kylix3_trial.tar.gz"
		 #ftp://ftpd.borland.com/download/kylix/k3/k3_trial_update_catalog.tar.gz
		 #ftp://ftpd.borland.com/download/kylix/k3/k3_proenttrial_update_float_locale.tar.gz
LICENSE="Shareware"
SLOT="0"
KEYWORDS="x86 -*"
#RESTRICT="fetch nostrip"
RESTRICT="nostrip mirror"
IUSE="db2 dbexpress doc gnome informix kde mozilla mysql oracle postgresql"
DEPEND="virtual/libc
	    virtual/x11
		>=media-libs/jpeg-6b
		>=x11-libs/gtk+-1.2
		mozilla? || ( www-client/mozilla
			www-client/mozilla-bin
			www-client/mozilla-firefox
			www-client/mozilla-firefox-bin)"
S="${WORKDIR}/kylix3_trial"

src_unpack() {
	unpack ${A}
	rpm_unpack ${S}/setup.data/packages/kylix3_main_program_files-1.0-1.i386.rpm
	rpm_unpack ${S}/setup.data/packages/kylix3_ide-1.0-1.i386.rpm
	rpm_unpack ${S}/setup.data/packages/kylix3_internet-1.0-1.i386.rpm
	rpm_unpack ${S}/setup.data/packages/kylix3_visicorba-1.0-1.i386.rpm
	rpm_unpack ${S}/setup.data/packages/kylix3_web_services-1.0-1.i386.rpm
	(use dbexpress || use mysql) || {
	  rpm_unpack ${S}/setup.data/packages/kylix3_db_express-1.0-1.i386.rpm
	  rpm_unpack ${S}/setup.data/packages/kylix3_web_snap-1.0-1.i386.rpm
	}
	use oracle || rpm_unpack ${S}/setup.data/packages/kylix3_db_oracle-1.0-1.i386.rpm
	use db2 || rpm_unpack ${S}/setup.data/packages/kylix3_db_db2-1.0-1.i386.rpm
	use informix || rpm_unpack ${S}/setup.data/packages/kylix3_db_informix-1.0-1.i386.rpm
	use postgresql || rpm_unpack ${S}/setup.data/packages/kylix3_db_postgres-1.0-1.i386.rpm
	use doc || rpm_unpack ${S}/setup.data/packages/kylix3_help_files-1.0-1.i386.rpm
	use mozilla || rpm_unpack ${S}/setup.data/packages/kylix3_mozilla-1.0-1.i386.rpm
}

src_compile() {
	einfo Nothing to compile
}

src_install() {
	cp -f setup.data/setup.xml setup.data/setup.portage.xml
	(use dbexpress || use mysql) || sed -is 's/dbExpress" install="true/dbExpress" install="false/' setup.data/setup.portage.xml
	use oracle || sed -is 's/Oracle" install="true/Oracle" install="false/' setup.data/setup.portage.xml
	use db2 || sed -is 's/DB2" install="true/DB2" install="false/' setup.data/setup.portage.xml
	use informix || sed -is 's/Informix" install="true/Informix" install="false/' setup.data/setup.portage.xml
	use postgresql || sed -is 's/Postgres" install="true/Postgres" install="false/' setup.data/setup.portage.xml
	use doc || sed -is 's/Help Files" install="true/Help Files" install="false/' setup.data/setup.portage.xml
	use mozilla || sed -is 's/Mozilla Widget" install="true/Mozilla Widget" install="false/' setup.data/setup.portage.xml
	for i in setup.data/*.sh
	do
	  sed -i -s 's:/usr/local:${D}/usr:' -s 's:/usr/lib:${D}/usr/lib' $i
	done
	mkdir -p ${D}/usr/bin
	setup.data/bin/x86/setup -m -n -a -i ${D}/opt/kylix3 -b ${D}/usr/bin -f	setup.data/setup.portage.xml
	einfo "Fixing symlinks"
	(
	  cd ${D}
	  for i in $(find -type l)
	  do
	    ln -sf "$(stat -c %N "$i" | cut -d \" -f 4 | sed -e "s:${D}::")" "$i"
	  done
	  einfo "Applying some patches"
	  #mv ${WORKDIR}/k3_trial_update_catalog/*.msg ${D}/opt/kylix3/bin
	  #${WORKDIR}/k3_proenttrial_update_float_locale/bin/patch ${D}/opt/kylix3 ${WORKDIR}/k3_proenttrial_update_float_locale/patch.rtp
	)
}

pkg_postinst() {
	einfo "If you don't have a key get one from http://ussvs-bes1.borland.com/WebDownload/userRegistration.jsp?sid=199"
}
