note
	description: "String 32 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:23:38 GMT (Wednesday 17th October 2018)"
	revision: "4"

class
	EL_STRING_32_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			empty_string as empty_string_32
		redefine
			new_string
		end

	EL_STRING_32_CONSTANTS

create
	make, make_default

convert
	make ({STRING_32})

feature {NONE} -- Implementation

	append_from_general (target: STRING_32; general: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} general as z_str then
				z_str.append_to_string_32 (target)
			else
				target.append (general.to_string_32)
			end
		end

	new_string (n: INTEGER): STRING_32
		do
			create Result.make (n)
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

end
