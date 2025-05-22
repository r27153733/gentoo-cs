# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/SagerNet/sing-geoip"
EGIT_REPO_URI="https://github.com/SagerNet/sing-geoip.git"

inherit git-r3 go-module

DESCRIPTION="sing-geoip rule sets and database"
HOMEPAGE="https://github.com/SagerNet/sing-geoip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+rule-set database"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.18"

REQUIRED_USE="|| ( rule-set database )"

S="${WORKDIR}/${P}"

src_unpack() {
	git-r3_src_unpack
	go-module_live_vendor
}

src_compile() {
	export CGO_ENABLED=0
	export GO111MODULE=on
	export GOPROXY=direct
	export GOSUMDB=off
	
	# Build the generator
	ego build -v -ldflags "-s -w" .
	
	# Generate rule sets and database
	NO_SKIP=true ./sing-geoip || die "Failed to generate geoip data"
}

src_install() {
	# Install license
	dodoc LICENSE README.md
	
	# Install rule sets if requested
	if use rule-set; then
		insinto /usr/share/sing-geoip
		doins -r rule-set
	fi
	
	# Install database files if requested
	if use database; then
		insinto /usr/share/sing-geoip
		doins *.db
	fi
}
