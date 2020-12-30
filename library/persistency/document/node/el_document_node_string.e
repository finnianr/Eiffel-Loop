note
	description: "Document node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-30 11:24:18 GMT (Wednesday 30th December 2020)"
	revision: "2"

class
	EL_DOCUMENT_NODE_STRING

inherit
	EL_UTF_8_STRING
		export
			{NONE} all
			{ANY} append_count_from_c, wipe_out
		redefine
			make, as_string_32, to_string_32
		end

	EL_READABLE
		rename
			read_character_8 as to_character_8,
			read_character_32 as to_character_32,
			read_integer_8 as to_integer_8,
			read_integer_16 as to_integer_16,
			read_integer_32 as to_integer,
			read_integer_64 as to_integer_64,
			read_natural_8 as to_natural_8,
			read_natural_16 as to_natural_16,
			read_natural_32 as to_natural,
			read_natural_64 as to_natural_64,
			read_real_32 as to_real,
			read_real_64 as to_double,
			read_string as to_string,
			read_string_8 as to_string_8,
			read_string_32 as to_string_32,
			read_boolean as to_boolean,
			read_pointer as to_pointer
		undefine
			copy, is_equal, out
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		undefine
			copy, is_equal, out
		end

	EL_SHARED_ONCE_STRING_32

	EL_SHARED_ONCE_ZSTRING

create
	make_empty

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_default
			Precursor (n)
		end

feature -- Conversion

	as_string_32, to_string_32: STRING_32
		do
			Result := once_decoded_32
			Result.adjust
			Result := Result.twin
		end

	to_character_32: CHARACTER_32
		local
			str_32: STRING_32; i, l_count: INTEGER; c: CHARACTER_32
		do
			str_32 := once_decoded_32
			if str_32.count = 1 then
				Result := str_32 [1]
			else
				l_count := str_32.count
				from i := 1 until Result /= '%U' or else i > l_count loop
					c := str_32 [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_character_8: CHARACTER
		local
			nb, i: INTEGER; l_area: like area; c: CHARACTER
		do
			l_area := area
			if count = 1 then
				Result := l_area [0]
			else
				nb := count
				from i := 0 until Result /= '%U' or else i = nb loop
					c := l_area [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_pointer: POINTER
		do
		end

	to_string: ZSTRING
		do
		end

feature {NONE} -- Implementation

	once_decoded: ZSTRING
		do
			Result := empty_once_string
			if encoded_as_utf (8) then
				if has_multi_byte_character then

					Result.adjust
				else
					Result.append_string_general (Current)
				end
			elseif encoded_as_latin (1) then
				Result.append_string_general (Current)
			else
				Result.append_string_general (Current)
			end
		end

	once_decoded_32: STRING_32
		local
			c: EL_UTF_CONVERTER
		do
			Result := empty_once_string_32
			if encoded_as_utf (8) then
				if has_multi_byte_character then
					c.utf_8_string_8_into_string_32 (Current, Result)
					Result.adjust
				else
					Result.append_string_general (Current)
				end
			elseif encoded_as_latin (1) then
				Result.append_string_general (Current)
			else
				Result.append_string_general (Current)
			end
		end

end