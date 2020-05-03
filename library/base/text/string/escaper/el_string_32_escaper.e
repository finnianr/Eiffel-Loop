note
	description: "String 32 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-03 8:01:37 GMT (Sunday 3rd May 2020)"
	revision: "5"

deferred class
	EL_STRING_32_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Implementation

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
