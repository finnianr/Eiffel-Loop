note
	description: "Look up native VTD xpath from string conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 9:35:53 GMT (Sunday 11th May 2025)"
	revision: "1"

class
	EL_NATIVE_XPATH_TABLE

inherit
	EL_CACHE_TABLE [EL_VTD_NATIVE_XPATH_I [COMPARABLE], READABLE_STRING_GENERAL]
		undefine
			same_keys
		end

	EL_STRING_GENERAL_TABLE [EL_VTD_NATIVE_XPATH_I [COMPARABLE]]
		rename
			item as cached_item
		end

create
	make

feature {NONE} -- Implementation

	new_item (key: READABLE_STRING_GENERAL): like item
		do
			create {EL_VTD_NATIVE_XPATH_IMP} Result.make (key)
		end

end