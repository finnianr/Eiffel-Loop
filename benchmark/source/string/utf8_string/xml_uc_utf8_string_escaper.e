note
	description: "Xml uc utf8 string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 10:00:13 GMT (Wednesday 22nd June 2022)"
	revision: "4"

class
	XML_UC_UTF8_STRING_ESCAPER

inherit
	XML_GENERAL_ESCAPER

create
	make, make_128_plus

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

	READABLE: STRING_8
		do
		end

feature {NONE} -- Constants

	Once_buffer: UC_UTF8_STRING
		once
			create Result.make_empty
		end
end
