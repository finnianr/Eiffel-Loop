import os

from eiffel_loop.package import TAR_GZ_SOFTWARE_PACKAGE

pkg = TAR_GZ_SOFTWARE_PACKAGE ('https://taglib.org/releases/taglib-1.11.1.tar.gz')

print pkg.basename, pkg.dest_dir, pkg.unpacked_dir

pkg.download ()
pkg.unpack ()

#pkg.build ('taglib-1.11.1', 'cmake -DCMAKE_BUILD_TYPE=Release .')




