note
	description: "Summary description for {EL_MODULE_ZLIB}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 21:51:13 GMT (Thursday 7th July 2016)"
	revision: "3"

class
	EL_MODULE_ZLIB

inherit
	EL_MODULE

feature -- Access

	Zlib: EL_ZLIB_ROUTINES
		once
			create Result
		end
end
