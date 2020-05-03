note
	description: "String 8 escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-03 8:01:08 GMT (Sunday 3rd May 2020)"
	revision: "5"

deferred class
	EL_STRING_8_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER

feature {NONE} -- Implementation

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
