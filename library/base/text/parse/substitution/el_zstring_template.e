note
	description: "Zstring template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_ZSTRING_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			empty_string as empty_zstring
		redefine
			new_string
		end

create
	make, make_default

convert
	make ({ZSTRING})

feature {NONE} -- Implementation

	append_from_general (target: ZSTRING; general: READABLE_STRING_GENERAL)
		do
			target.append_string_general (general)
		end

	new_string (n: INTEGER): ZSTRING
		do
			create Result.make (n)
		end

	wipe_out (str: ZSTRING)
		do
			str.wipe_out
		end

end
