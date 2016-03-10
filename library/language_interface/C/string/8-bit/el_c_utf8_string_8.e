note
	description: "Summary description for {EL_C_UTF8_STRING_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_C_UTF8_STRING_8

inherit
	EL_C_STRING_8
		redefine
			fill_string
		end

	EL_UC_ROUTINES
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Set external strings

	fill_string (string: STRING_GENERAL)
			-- Fill string argument with latin-1 encoded characters
		local
			utf8_code, a_byte_code: NATURAL
			i, utf8_byte_count, nb: INTEGER
		do
			from i := 1 until i > count loop
				a_byte_code := item (i)
				utf8_byte_count := encoded_byte_count (a_byte_code)
				if utf8_byte_count > 1 then
					utf8_code := encoded_first_value (a_byte_code)
					nb := i + utf8_byte_count - 1

					from i := i + 1 until i > nb.min (count) loop
						a_byte_code := item (i)
						utf8_code := utf8_code * 64 + encoded_next_value (a_byte_code)
						i := i + 1
					end
					string.append_code (utf8_code)
				else
					string.append_code (a_byte_code)
					i := i + 1
				end
			end
		end

end
