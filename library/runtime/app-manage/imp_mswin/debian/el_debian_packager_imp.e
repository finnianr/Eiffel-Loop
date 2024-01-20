note
	description: "Windows implementation of ${EL_DEBIAN_PACKAGER_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

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