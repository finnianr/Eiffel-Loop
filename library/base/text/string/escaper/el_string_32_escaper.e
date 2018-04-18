note
	description: "Summary description for {EL_STRING_32_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-03 13:56:52 GMT (Tuesday 3rd April 2018)"
	revision: "1"

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
