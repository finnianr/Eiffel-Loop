note
	description: "Class for Debian package model experiment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	LIBC6

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "2.19-0ubuntu6.15"
		end

end