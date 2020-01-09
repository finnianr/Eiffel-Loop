note
	description: "Class for Debian package model experiment"
	Package_description: "[
		GCC support library

		Shared version of the support library, a library of internal subroutines
		that GCC uses to overcome shortcomings of particular machines, or
		special needs for some languages.
	]"
	Essential: "yes"
	Priority: "required"
	Section: "libs"
	Installed_Size: "129"
	Maintainer: "Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>"
	Architecture: "amd64"
	Multi_Arch: "same"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 18:04:05 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	LIBGCC1 -- libgcc1

inherit
--	Depends: gcc-4.9-base
	GCC_4_9_BASE
		rename
			version as gcc_4_9_base
		end

--	PreDepends: multiarch-support
	MULTIARCH_SUPPORT
		rename
			version as multiarch_support
		end

--	Pre-depends: libc6
	LIBC6
		rename
			version as libc6
		end

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "1:4.9.3-0ubuntu4"
		end

invariant
	version_constraint: gcc_4_9_base ~ "4.9-20140406-0ubuntu1"
	version_constraint: libc6 >= "2.14"
end
