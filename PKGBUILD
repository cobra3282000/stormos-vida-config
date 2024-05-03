pkgname=stormos-budgie-config
_destname1="/etc"
pkgver=24.05
pkgrel=1
pkgdesc="Desktop Config for StormOS"
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
