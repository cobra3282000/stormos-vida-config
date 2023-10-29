# Maintainer: DarkXero <info@techxero.com>
pkgname=stormos-xfce-config
_destname1="/etc"
pkgver=23.11
pkgrel=2
pkgdesc="Desktop Config for StormOS XFCE"
arch=('any')
url="https://github.com/bfitzgit23"
license=('GPL3')
makedepends=('git')
conflicts=()
provides=("${pkgname}")
options=(!strip !emptydirs)
source=(${pkgname}::"git+${url}/${pkgname}")
sha256sums=('SKIP')
package() {
	install -dm755 ${pkgdir}${_destname1}
	cp -r ${srcdir}/${pkgname}${_destname1}/* ${pkgdir}${_destname1}
	rm ${srcdir}/${pkgname}/git_clean.sh
	rm ${srcdir}/${pkgname}/git_push.sh
	rm ${srcdir}/${pkgname}/git_setup.sh
	rm ${srcdir}/${pkgname}/PKGBUILD
}
