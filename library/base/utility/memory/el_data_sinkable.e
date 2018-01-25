note
	description: "Summary description for {EL_DATA_SINK}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 12:32:16 GMT (Thursday 28th December 2017)"
	revision: "1"

deferred class
	EL_DATA_SINKABLE

inherit
	STRING_HANDLER

	EL_WRITEABLE
		rename
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

feature -- General sinks

	sink_special (in: SPECIAL [NATURAL_8]; in_lower: INTEGER_32; in_upper: INTEGER_32)
		deferred
		end

	sink_boolean (in: BOOLEAN)
		do
			sink_integer_32 (in.to_integer)
		end

	sink_pointer (in: POINTER)
		do
			sink_integer_32 (in.to_integer_32)
		end

feature -- Integer sinks

	sink_integer_8 (in: INTEGER_8)
		do
			sink_character_8 (in.to_character_8)
		end

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

feature -- Natural sinks

	sink_natural_8 (in: NATURAL_8)
		do
			sink_character_8 (in.to_character_8)
		end

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
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := a_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

	sink_bytes (byte_array: EL_BYTE_ARRAY)
		local
			l_area: SPECIAL [NATURAL_8]
		do
			l_area := byte_array
			sink_special (l_area, l_area.lower, l_area.upper)
		end

feature -- Character sinks

	sink_character_8 (in: CHARACTER_8)
		deferred
		end

	sink_character_32 (in: CHARACTER_32)
		do
			sink_natural_32 (in.natural_32_code)
		end

feature -- String sinks

	sink_joined_strings (list: CHAIN [ZSTRING]; delimiter: CHARACTER_32)
		do
			from list.start until list.after loop
				if list.index > 1 then
					sink_character_32 (delimiter)
				end
				sink_string (list.item)
				list.forth
			end
		end

	sink_joined_strings_32 (list: CHAIN [STRING_32]; delimiter: CHARACTER_32)
		do
			from list.start until list.after loop
				if list.index > 1 then
					sink_character_32 (delimiter)
				end
				sink_string_32 (list.item)
				list.forth
			end
		end

	sink_joined_strings_8 (list: CHAIN [STRING]; delimiter: CHARACTER)
		do
			from list.start until list.after loop
				if list.index > 1 then
					sink_character_8 (delimiter)
				end
				sink_string_8 (list.item)
				list.forth
			end
		end

	sink_string (in: ZSTRING)
		local
			l_area: SPECIAL [NATURAL]; i, count: INTEGER
			l_area_8: SPECIAL [CHARACTER]
		do
			l_area_8 := in.area; count := in.count
			from i := 0 until i = count loop
				sink_character_8 (l_area_8.item (i))
				i := i + 1
			end
			-- Unencoded
			l_area := in.unencoded_area; count := l_area.count
			from i := 0 until i = count loop
				sink_natural_32 (l_area.item (i))
				i := i + 1
			end
		end

	sink_string_32 (in: STRING_32)
		local
			l_area: SPECIAL [CHARACTER_32]; i, count: INTEGER
		do
			l_area := in.area; count := in.count
			from i := 0 until i = count loop
				sink_character_32 (l_area.item (i))
				i := i + 1
			end
		end

	sink_string_8 (in: STRING)
		deferred
		end

feature {NONE} -- Constants

	Memory: MANAGED_POINTER
		once
			create Result.make (8)
		end
end
