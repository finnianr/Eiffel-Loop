note
	description: "Summary description for {EL_MODULE_ZLIB}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_MODULE_ZLIB

feature -- Access

	Zlib: EL_ZLIB_ROUTINES
		once
			create Result
		end
end
