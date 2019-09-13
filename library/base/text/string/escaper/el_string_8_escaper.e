note
	description: "String 8 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-13 8:37:14 GMT (Friday 13th September 2019)"
	revision: "4"

deferred class
	EL_STRING_8_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Implementation

	new_string (n: INTEGER): STRING_8
		do
			create Result.make (n)
		end

	wipe_out (str: like once_buffer)
		do
			str.wipe_out
		end

feature {NONE} -- Type definitions

	READABLE: READABLE_STRING_8
		do
		end

feature {NONE} -- Constants

	Once_buffer: STRING_8
		once
			create Result.make_empty
		end
end
