note
	description: "Data sinkable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 14:03:49 GMT (Thursday 3rd April 2025)"
	revision: "32"

deferred class
	EL_DATA_SINKABLE

inherit
	EL_WRITABLE
		rename
			write_encoded_character_8 as sink_raw_character_8, -- Allows UTF-8 conversion
			write_encoded_string_8 as sink_raw_string_8,

			write_character_8 as sink_character_8,
			write_character_32 as sink_character_32,
			write_integer_8 as sink_integer_8,
			write_integer_16 as sink_integer_16,
			write_integer_32 as sink_integer_32,
			write_integer_64 as sink_integer_64,
			write_natural_8 as sink_natural_8,
			write_natural_16 as sink_natural_16,
			write_natural_32 as sink_natural_32,
			write_natural_64 as sink_natural_64,
			write_real_32 as sink_real_32,
			write_real_64 as sink_real_64,
			write_string as sink_string,
			write_string_8 as sink_string_8,
			write_string_32 as sink_string_32,
			write_string_general as sink_string_general,
			write_boolean as sink_boolean,
			write_pointer as sink_pointer
		end

	EL_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

	EL_SHARED_UTF_8_SEQUENCE

feature -- Measurement

	byte_width: INTEGER
		deferred
		end

feature -- Status query

	utf_8_mode_enabled: BOOLEAN
		-- when `True' then strings and characters arguments are encoded as UTF-8
		-- and sunk via `sink_raw_character_8'

feature -- Status change

	disable_utf_8_mode
		do
			utf_8_mode_enabled := False
		end

	enable_utf_8_mode
		do
			utf_8_mode_enabled := True
		end

	reset
		deferred
		end

feature -- General sinks

	sink_boolean (in: BOOLEAN)
		do
			sink_integer_32 (in.to_integer)
		end

	sink_character_array (in: SPECIAL [CHARACTER]; in_lower: INTEGER_32; in_upper: INTEGER_32)
		require
			valid_lower: in.valid_index (in_lower)
			valid_upper: in_upper = in_lower - 1 or else in.valid_index (in_upper)
		local
			i: INTEGER
		do
			from i := in_lower until i > in_upper loop
				sink_character_8 (in [i])
				i := i + 1
			variant
				in_upper - i + 2
			end
		end

	sink_memory (in: MANAGED_POINTER)
		local
			i: INTEGER
		do
			from i := 0 until i = in.count loop
				sink_natural_8 (in.read_natural_8 (i))
				i := i + 1
			end
		end

	sink_pointer (in: POINTER)
		do
			sink_integer_32 (in.to_integer_32)
		end

	sink_special (in: SPECIAL [NATURAL_8]; in_lower: INTEGER_32; in_upper: INTEGER_32)
		-- sink `in' array starting with `in_lower' index
		deferred
		end

	sink_special_reversed (in: SPECIAL [NATURAL_8]; in_lower: INTEGER_32; in_upper: INTEGER_32)
		-- sink `in' array starting with `in_upper' index
		deferred
		end

feature -- Integer sinks

	sink_integer_16 (in: INTEGER_16)
		do
			sink_character_8 ((in |>> 8).to_character_8)
			sink_character_8 (in.to_character_8)
		end

	sink_integer_32 (in: INTEGER)
		do
			sink_natural_32 (in.to_natural_32)
		end

	sink_integer_64 (in: INTEGER_64)
		do
			sink_natural_32 ((in |>> 32).to_natural_32)
			sink_natural_32 (in.to_natural_32)
		end

	sink_integer_8 (in: INTEGER_8)
		do
			sink_character_8 (in.to_character_8)
		end

feature -- Natural sinks

	sink_natural_16 (in: NATURAL_16)
		do
			sink_character_8 ((in |>> 8).to_character_8)
			sink_character_8 (in.to_character_8)
		end

	sink_natural_32 (in: NATURAL_32)
		deferred
		end

	sink_natural_64 (in: NATURAL_64)
		do
			sink_natural_32 ((in |>> 32).to_natural_32)
			sink_natural_32 (in.to_natural_32)
		end

	sink_natural_8 (in: NATURAL_8)
		do
			sink_character_8 (in.to_character_8)
		end

feature -- Real sinks

	sink_real_32 (in: REAL)
		local
			mem: like Memory
		do
			mem := Memory
			mem.put_real_32_be (in, 0)
			sink_natural_32 (mem.read_natural_32_be (0))
		end

	sink_real_64 (in: REAL_64)
		local
			mem: like Memory
		do
			mem := Memory
			mem.put_real_64_be (in, 0)
			sink_natural_64 (mem.read_natural_64_be (0))
		end

feature -- Array sinks

	sink_array (a_array: ARRAY [NATURAL_8])
		-- sink `a_array' starting with `lower' index
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := a_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

	sink_array_reversed (a_array: ARRAY [NATURAL_8])
		-- sink `a_array' starting with `upper' index
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := a_array
			sink_special_reversed (l_area, l_area.lower, l_area.upper)
		end

	sink_bytes (byte_array: EL_BYTE_ARRAY)
		-- sink `byte_array' starting with `lower' index
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := byte_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

	sink_bytes_reversed (byte_array: EL_BYTE_ARRAY)
		-- sink `byte_array' starting with `upper' index
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := byte_array
			sink_special_reversed (l_area, l_area.lower, l_area.upper)
		end

feature -- Character sinks

	sink_character_32 (in: CHARACTER_32)
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			if utf_8_mode_enabled then
				c.write_utf_8 (in, Current)
			else
				sink_natural_32 (in.natural_32_code)
			end
		end

	sink_character_8 (in: CHARACTER_8)
		do
			if utf_8_mode_enabled then
				sink_character_32 (in)
			else
				sink_raw_character_8 (in)
			end
		end

feature -- String sinks

	sink_joined_strings (list: ITERABLE [READABLE_STRING_GENERAL]; delimiter: CHARACTER_32)
		local
			not_first: BOOLEAN
		do
			across list as str loop
				if not_first then
					if delimiter.is_character_8 then
						sink_character_8 (delimiter.to_character_8)
					else
						sink_character_32 (delimiter)
					end
				else
					not_first := True
				end
				sink_string_general (str.item)
			end
		end

	sink_string (in: EL_READABLE_ZSTRING)
		local
			l_area: SPECIAL [CHARACTER_32]; i, count: INTEGER
		do
			if utf_8_mode_enabled then
				in.write_utf_8_to (Current)
			else
				sink_character_array (in.area, 0, in.count - 1)
				-- Unencoded
				l_area := in.unencoded_area; count := l_area.count
				from i := 0 until i = count loop
					sink_natural_32 (l_area [i].natural_32_code)
					i := i + 1
				end
			end
		end

	sink_string_32 (in: READABLE_STRING_32)
		local
			l_area: SPECIAL [CHARACTER_32]; i, i_lower, i_upper: INTEGER
		do
			if is_zstring (in) and then attached {EL_READABLE_ZSTRING} in as z_str then
				sink_string (z_str)

			elseif utf_8_mode_enabled then
				super_readable_32 (in).write_utf_8_to (Current)
			else
				if in.is_immutable and then attached super_readable_32 (in) as s then
					l_area := s.area; i_lower := s.index_lower; i_upper := s.index_upper

				elseif attached {STRING_32} in as str_32 then
					l_area := str_32.area; i_upper := str_32.count - 1
				end
				from i := i_lower until i > i_upper loop
					sink_natural_32 (l_area [i].natural_32_code)
					i := i + 1
				end
			end
		end

	sink_string_8 (in: READABLE_STRING_8)
		local
			l_area: SPECIAL [CHARACTER_8]; i, i_lower, i_upper: INTEGER
		do
			if utf_8_mode_enabled then
				super_readable_8 (in).write_utf_8_to (Current)
			else
				if in.is_immutable and then attached super_readable_8 (in) as s then
					l_area := s.area; i_lower := s.index_lower; i_upper := s.index_upper

				elseif attached {STRING_8} in as str_32 then
					l_area := str_32.area; i_upper := str_32.count - 1
				end
				from i := i_lower until i > i_upper loop
					sink_raw_character_8 (l_area [i])
					i := i + 1
				end
			end
		end

feature {NONE} -- Constants

	Memory: MANAGED_POINTER
		once
			create Result.make (8)
		end
end