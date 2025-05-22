# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/SagerNet/sing-geosite"
EGIT_REPO_URI="https://github.com/SagerNet/sing-geosite.git"

inherit git-r3 go-module

DESCRIPTION="sing-geosite rule sets and database"
HOMEPAGE="https://github.com/SagerNet/sing-geosite"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+rule-set database"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.18"

REQUIRED_USE="|| ( rule-set database )"

RESTRICT="network-sandbox"

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
	
	# Generate rule sets and database with network access
	NO_SKIP=true ./sing-geosite || die "Failed to generate geosite data"
}

src_install() {
	# Install license and documentation if they exist
	[[ -f LICENSE ]] && dodoc LICENSE
	[[ -f README.md ]] && dodoc README.md
	[[ -f README ]] && dodoc README
	
	# Install rule sets if requested
	if use rule-set && [[ -d "rule-set" ]]; then
		insinto /usr/share/sing-geosite
		doins -r rule-set
		einfo "Installed $(find rule-set -name "*.srs" | wc -l) rule-set files"
	fi
	
	# Install database files if requested
	if use database; then
		local db_files=( *.db )
		if [[ -f "${db_files[0]}" ]]; then
			insinto /usr/share/sing-geosite
			doins *.db
			einfo "Installed database files: ${db_files[*]}"
		else
			ewarn "No database files found to install"
		fi
	fi
}
