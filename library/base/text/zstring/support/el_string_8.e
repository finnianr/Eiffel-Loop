note
	description: "Extensions for `STRING_8'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-11 18:11:22 GMT (Monday 11th January 2021)"
	revision: "6"

class
	EL_STRING_8

inherit
	STRING_8
		export
			{STRING_HANDLER} make_from_string
		end

create
	make_from_zstring, make_empty, make

feature {NONE} -- Initialization

	make_from_zstring (zstr: EL_ZSTRING_CHARACTER_8_IMPLEMENTATION)
		do
			set_area_and_count (zstr.area, zstr.count)
		end

feature -- Staus query

	is_7_bit: BOOLEAN
		-- `True' if all characters in `Current' are <= 0x7F
		do
			Result := is_7_bit_string (Current)
		end

	is_7_bit_string (str: READABLE_STRING_8): BOOLEAN
		-- `True' if all characters in `str' are <= 0x7F
		local
			l_area: like area; i, upper: INTEGER
		do
			l_area := str.area; upper := str.area_upper
			Result := True
			from i := str.area_lower until not Result or else i > upper loop
				if l_area [i] > '%/0x7F/' then
					Result := False
				end
				i := i + 1
			end
		end

feature -- Measurement

	leading_white_count: INTEGER
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.leading_white_count (Current)
		end

	trailing_white_count: INTEGER
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.trailing_white_count (Current)
		end

feature -- Basic operations

	append_adjusted_to (str: STRING)
		local
			n, i, start_index, end_index, offset: INTEGER; str_32: STRING_32
			l_area, o_area: like area
		do
			end_index := count - trailing_white_count
			if end_index.to_boolean then
				start_index := leading_white_count + 1
			else
				start_index := 1
			end
			n := end_index - start_index + 1
			offset := str.count
			str.grow (offset + n)
			str.set_count (offset + n)
			l_area := area; o_area := str.area
			from i := 0 until i = n loop
				o_area [i + offset] := l_area [i + start_index - 1]
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

	set_area_and_count (a_area: like area; a_count: INTEGER)
		do
			area := a_area; count := a_count
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

end