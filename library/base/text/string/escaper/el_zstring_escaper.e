note
	description: "Zstring escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_ZSTRING_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Implementation

	wipe_out (str: like once_buffer)
		do
			str.wipe_out
		end

feature {NONE} -- Type definitions

	READABLE: EL_READABLE_ZSTRING
		do
		end

feature {NONE} -- Constants

	Once_buffer: ZSTRING
		once
			create Result.make_empty
		end
end
