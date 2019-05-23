note
	Description: "[
		GNU version of the tar archiving utility
		
		Tar is a program for packaging a set of files as a single archive in tar
		format.  The function it performs is conceptually similar to cpio, and to
		things like PKZIP in the DOS world.  It is heavily used by the Debian package
		management system, and is useful for performing system backups and exchanging
		sets of files with others.
	]"
	Essential: "yes"
	Priority: "required"
	Section: "utils"
	Installed_Size: "768"
	Maintainer: "Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>"
	Architecture: "amd64"
	Multi_Arch: "foreign"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-17 13:21:44 GMT (Friday 17th May 2019)"
	revision: "1"

class
	TAR -- tar

inherit
--	Pre-depends: libacl1
	LIBACL1
		rename
			version as libacl1
		end

--	Pre-depends: libselinux1
	LIBSELINUX1
		rename
			version as libselinux1
		end

--	Pre-depends: libc6
	LIBC6
		rename
			version as libc6
		end

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "1.27.1-1ubuntu0.1"
		end

invariant
	libacl1_version: libacl1 >= "2.2.51-8"
	libselinux1_version: libselinux1 >= "1.32"
	libc6_version: libc6 >= "2.17"
end
