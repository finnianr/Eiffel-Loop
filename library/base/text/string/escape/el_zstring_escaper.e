note
	description: "Zstring escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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