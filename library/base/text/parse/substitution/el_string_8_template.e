note
	description: "String 8 template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	EL_STRING_8_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			empty_string as empty_string_8
		redefine
			new_string
		end

create
	make, make_default

convert
	make ({STRING_8})

feature {NONE} -- Implementation

	append_from_general (target: STRING_8; general: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} general as z_str then
				z_str.append_to_string_8 (target)
			else
				target.append (general.to_string_8)
			end
		end

	new_string (n: INTEGER): STRING_8
		do
			create Result.make (n)
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end

end
