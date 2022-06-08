# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

KEYWORDS="~amd64 ~arm64"
DESCRIPTION="Service account for Collabora Online"

ACCT_USER_GROUPS=( ${PN} )
ACCT_USER_ID="-1"
ACCT_USER_HOME="/opt/${PN}"
ACCT_USER_HOME_PERMS="700"

acct-user_add_deps
