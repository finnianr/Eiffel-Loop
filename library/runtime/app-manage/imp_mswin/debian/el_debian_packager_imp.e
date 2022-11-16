note
	description: "Windows implementation of [$source EL_DEBIAN_PACKAGER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_DEBIAN_PACKAGER_IMP

inherit
	EL_DEBIAN_PACKAGER_I

create
	make

feature {NONE} -- Implementation

	put_xdg_entries
		do
		end

end