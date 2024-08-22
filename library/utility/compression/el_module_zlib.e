note
	description: "Shared access to routines of class ${EL_ZLIB_ROUTINES}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 8:28:33 GMT (Thursday 22nd August 2024)"
	revision: "11"

deferred class
	EL_MODULE_ZLIB

inherit
	EL_MODULE

feature {NONE} -- Constants

	Zlib: EL_ZLIB_ROUTINES_IMP
		once
			create Result
		end
end