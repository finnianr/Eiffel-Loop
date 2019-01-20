note
	description: "Zstring template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-20 12:53:07 GMT (Sunday 20th January 2019)"
	revision: "5"

class
	EL_ZSTRING_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			empty_string as empty_zstring
		redefine
			new_string
		end

	EL_ZSTRING_CONSTANTS
		rename
			empty_string as empty_zstring
		end

create
	make, make_default

convert
	make ({ZSTRING})

feature {NONE} -- Implementation

	append_from_general (target: ZSTRING; a_general: READABLE_STRING_GENERAL)
		do
			target.append_string_general (a_general)
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
