note
	description: "Class for Debian package model experiment"
	Package_description: "[
		Transitional package to ensure multiarch compatibility
		This is a transitional package used to ensure multiarch support is present
		in ld.so before unpacking libraries to the multiarch directories.  It can
		be removed once nothing on the system depends on it.
	]"
	Package: "multiarch-support"
	Priority: "required"
	Section: "libs"
	Installed_Size: "204"
	Maintainer: "Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>"
	Architecture: "amd64"
	Multi_arch: "foreign"
	Source: "eglibc"
	Version: "2.19-0ubuntu6.15"
	Filename: "pool/main/e/eglibc/multiarch-support_2.19-0ubuntu6_amd64.deb"
	Size: "4490"
	MD5sum: "9b4bd397ec28b891176e902acb895685"
	Homepage: "http://www.eglibc.org"
	Original_maintainer: "GNU Libc Maintainers <debian-glibc@lists.debian.org>"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 18:04:13 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	MULTIARCH_SUPPORT

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "2.19-0ubuntu6.15"
		end

end
