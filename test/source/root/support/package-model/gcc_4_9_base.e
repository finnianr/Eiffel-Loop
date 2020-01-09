note
	description: "Class for Debian package model experiment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 18:02:46 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	GCC_4_9_BASE -- gcc-4.9-base

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "4.9.3-0ubuntu4"
		end
end
