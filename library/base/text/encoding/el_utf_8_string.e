note
	description: "String encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 17:01:28 GMT (Saturday 2nd January 2021)"
	revision: "3"

class
	EL_UTF_8_STRING

inherit
	EL_STRING_8

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_ZSTRING

create
	make

feature -- Status query

	has_multi_byte_character: BOOLEAN
		do
			Result := not is_7_bit
		end

feature -- Element change

	set_from_general (str: READABLE_STRING_GENERAL)
		local
			c: EL_UTF_CONVERTER
		do
			wipe_out
			grow (str.count)
			if attached {ZSTRING} str as zstr then
				zstr.append_to_utf_8 (Current)
			else
				c.utf_32_string_into_utf_8_string_8 (str, Current)
			end
		end

feature {NONE} -- Implementation

	once_decoded: ZSTRING
		do
			Result := empty_once_string
			Result.append_utf_8 (Current)
		end

	once_decoded_32: STRING_32
		local
			c: EL_UTF_CONVERTER
		do
			Result := empty_once_string_32
			if has_multi_byte_character then
				c.utf_8_string_8_into_string_32 (Current, Result)
			else
				Result.append_string_general (Current)
			end
		end
end