#!/bin/bash

set -e

pkgdir="packages"
scrdir="scripts"
dstdir="dist"

if ! [ -d "$pkgdir" ]; then
	echo "Run this in the project root dir"
	exit 1
fi

built=""

rm -fr "$dstdir"
mkdir -p "$dstdir"

version="$(date +%Y.%m.%d)-1"

for pkg in "$pkgdir"/*; do
	if [ "${pkg:0-4}" == ".res" ] ||  [ "${pkg:0-4}" == ".bin" ]; then continue; fi
	pkg="${pkg:9}"
	dir="${pkg}_${version}_all"
	mkdir -p "$dir/DEBIAN" && cd "$dir"
	mkdir -p "usr/bin"
	if [ -f "../$pkgdir/${pkg}.bin" ]; then
		while read -u 7 line; do
			if [ -n "$line" ]; then
				cp "../$scrdir/$line" usr/bin/
			fi
		done 7<"../$pkgdir/${pkg}.bin"
	else
		cp "../$scrdir/$pkg" usr/bin/
	fi
	chmod a+x usr/bin/*
	if [ -f "../$pkgdir/${pkg}.res" ]; then
		while read -u 7 line; do
			line=${line##+(/)}
			if [ -n "$line" ] && [ -f "../res/${line##*/}" ]; then
				if [ -n "${line%/*}" ]; then
					mkdir -p "${line%/*}"
				fi
				cp -v "../res/${line##*/}" "$line"
			fi
		done 7<"../$pkgdir/${pkg}.res"
	fi
	for d in *; do
		if [ -d "$d" ] && [ "$d" != "DEBIAN" ]; then
			find "$d" -type f -exec md5sum -b "{}" >>DEBIAN/md5sums \;
		fi
	done
	echo "Package: $pkg" >"DEBIAN/control"
	echo "Version: $version" >>"DEBIAN/control"
	echo "Installed-Size: $(du -sk .|sed -r 's/([0-9]+).+/\1/')" >>"DEBIAN/control"
	cat >>DEBIAN/control <<EOF
Source: sundman-scripts
Maintainer: Marcus Sundman <sundman@iki.fi>
Priority: optional
Breaks: sundman-scripts (<< 2016.07.10)
Architecture: all
EOF
	cat "../$pkgdir/$pkg" >>"DEBIAN/control"
	cd ..
	echo "Making ${dir}.deb"
	fakeroot dpkg-deb --build "$dir"
	mv "${dir}.deb" "$dstdir/"
	rm -r "$dir"
	if [ -n "$built" ]; then built="${built}, "; fi
	built="${built}${pkg}"
done
pkg="sundman-scripts"
dir="${pkg}_${version}_all"
mkdir -p "$dir/DEBIAN"
echo "Package: $pkg" >"$dir/DEBIAN/control"
echo "Version: $version" >>"$dir/DEBIAN/control"
echo "Depends: $built" >>"$dir/DEBIAN/control"
cat >>"$dir/DEBIAN/control" <<EOF
Source: sundman-scripts
Maintainer: Marcus Sundman <sundman@iki.fi>
Priority: optional
Architecture: all
Description: Meta-package for some handy scripts.
EOF
fakeroot dpkg-deb --build "$dir"
mv "${dir}.deb" "$dstdir/"
rm -r "$dir"
