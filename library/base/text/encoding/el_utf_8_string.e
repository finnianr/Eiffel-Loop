note
	description: "String encoded as UTF-8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-30 11:23:11 GMT (Wednesday 30th December 2020)"
	revision: "1"

class
	EL_UTF_8_STRING

inherit
	STRING_8

create
	make

feature -- Status query

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

feature -- Contract Support

	is_single_byte_sequence (a_utf_8: READABLE_STRING_8): BOOLEAN
		local
			l_area: like area; i, l_upper: INTEGER; found: BOOLEAN
		do
			l_area := a_utf_8.area; l_upper :=  a_utf_8.area_upper
			from i := a_utf_8.area_lower until found or i > l_upper loop
				found := l_area.item (i).code > 0x7F
				i := i + 1
			end
			Result := not found
		end

end