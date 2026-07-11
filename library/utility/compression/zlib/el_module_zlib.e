note
	description: "Shared access to routines of class ${EL_ZLIB_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 14:07:13 GMT (Sunday 30th March 2025)"
	revision: "12"

deferred class
	EL_MODULE_ZLIB

inherit
	EL_MODULE

feature {NONE} -- Constants

	Zlib: EL_ZLIB_ROUTINES_I
		once
			create Result
		end
end