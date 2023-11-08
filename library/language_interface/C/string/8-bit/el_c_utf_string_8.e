note
	description: "UTF-8 C string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 16:21:35 GMT (Wednesday 8th November 2023)"
	revision: "10"

class
	EL_C_UTF_STRING_8

inherit
	EL_C_STRING_8
		rename
			make_from_string as make_from_utf_8
		redefine
			fill_string
		end

	EL_UC_ROUTINES
		export
			{NONE} all
		undefine
			default_create, is_equal, copy
		end

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make,
	make_from_utf_8, make_from_general

convert
	make_from_general ({STRING_8, IMMUTABLE_STRING_8, STRING_32, ZSTRING})

feature {NONE} -- Initialization

	make_from_general (str: READABLE_STRING_GENERAL)
		do
			across String_8_scope as scope loop
				if attached scope.copied_utf_8_item (str) as utf_8 then
					make_from_utf_8 (utf_8)
				end
			end
		end

feature -- Set external strings

	fill_string (string: STRING_GENERAL)
			-- fill string with UTF-8 encoded characters
		local
			utf8_code, a_byte_code: NATURAL
			i, utf8_byte_count, nb: INTEGER
		do
			from i := 1 until i > count loop
				a_byte_code := code (i)
				utf8_byte_count := encoded_byte_count (a_byte_code)
				if utf8_byte_count > 1 then
					utf8_code := encoded_first_value (a_byte_code)
					nb := i + utf8_byte_count - 1

					from i := i + 1 until i > nb.min (count) loop
						a_byte_code := code (i)
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