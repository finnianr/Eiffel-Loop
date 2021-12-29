note
	description: "Shared access to routines of class [$source EL_STRING_32_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-14 12:43:22 GMT (Tuesday 14th September 2021)"
	revision: "9"

deferred class
	EL_MODULE_STRING_32

obsolete
	"Very slow compared to local expanded"

inherit
	EL_MODULE

feature {NONE} -- Implementation

	String_32: EL_STRING_32_ROUTINES
		-- expanded instance
		do
		end

end
