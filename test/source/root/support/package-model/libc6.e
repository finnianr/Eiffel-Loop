note
	description: "Class for Debian package model experiment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 18:02:50 GMT (Wednesday 8th January 2020)"
	revision: "2"

class
	LIBC6

feature -- Access

	version: DEBIAN_VERSION
		once
			Result := "2.19-0ubuntu6.15"
		end

end
