note
	description: "String 32 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-13 8:36:57 GMT (Friday 13th September 2019)"
	revision: "4"

deferred class
	EL_STRING_32_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Implementation

	new_string (n: INTEGER): STRING_32
		do
			create Result.make (n)
		end

	wipe_out (str: like once_buffer)
		do
			str.wipe_out
		end

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_32
		do
		end

feature {NONE} -- Constants

	Once_buffer: STRING_32
		once
			create Result.make_empty
		end
end
