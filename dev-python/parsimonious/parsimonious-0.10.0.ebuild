# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1 pypi

DESCRIPTION="pure-Python PEG parser"
HOMEPAGE="https://github.com/erikrose/parsimonious/
	https://pypi.org/project/parsimonious/"
#S=${WORKDIR}/${P^}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="doc"

distutils_enable_tests pytest

python_test() {
	setup.py test
}
