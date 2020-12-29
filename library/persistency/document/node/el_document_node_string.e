note
	description: "Document node string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-29 18:42:23 GMT (Tuesday 29th December 2020)"
	revision: "1"

class
	EL_DOCUMENT_NODE_STRING

inherit
	STRING
		export
			{NONE} all
			{ANY} wipe_out
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

feature -- Element change

	append_count_from_c (c_string: POINTER; a_count: INTEGER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer_and_count (c_string, a_count)
			grow (count + a_count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, count, a_count)
			count := count + a_count
			internal_hash_code := 0
		end

	append_from_c (c_string: POINTER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer (c_string)
			grow (count + c.count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, count, c.count)
			count := count + c.count
			internal_hash_code := 0
		end

	set_from_c (c_string: POINTER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer (c_string)
			grow (c.count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, 0, c.count)
			count := c.count
			internal_hash_code := 0
		end

	set_from_c_with_count (c_string: POINTER; a_count: INTEGER)
		local
			c: like C_string_provider
		do
			c := C_string_provider
			c.set_shared_from_pointer_and_count (c_string, a_count)
			grow (a_count + 1)
			c.managed_data.read_into_special_character_8 (area, 0, 0, a_count)
			count := a_count
			internal_hash_code := 0
		end

feature {NONE} -- Implementation

	has_multi_byte_character: BOOLEAN
		local
			l_area: like area; i, l_count: INTEGER
		do
			l_area := area; l_count := count
			from i := 1 until Result or i = l_count loop
				Result := l_area.item (i).code > 0x7F
				i := i + 1
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