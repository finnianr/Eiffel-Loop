note
	description: "Universally unique identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-30 11:26:03 GMT (Monday 30th March 2020)"
	revision: "17"

class
	EL_UUID

inherit
	UUID
		rename
			make_from_string as make_from_string_general
		undefine
			is_equal
		end

	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		undefine
			out
		redefine
			ordered_alphabetically
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_string
		undefine
			out, is_equal
		end

create
	make_default, make, make_from_string_general, make_from_string, make_from_array

feature {NONE} -- Implementation

	make_from_string (str: STRING)
		do
			make_from_string_general (str)
		end

feature -- Access

	to_delimited (c: CHARACTER): STRING
		local
			i: INTEGER
		do
			Result := to_string
			from i := 1 until i > Result.count loop
				inspect i
					when 9, 14, 19, 24 then
						Result.put (c, i)
				else
				end
				i := i + 1
			end
		end

	to_string: STRING
		local
			start_index, end_index, i, j: INTEGER
			n, digit: NATURAL_64; array: SPECIAL [NATURAL_64]
		do
			create Result.make_filled (Separator_char_8, 36)
			create array.make_filled (data_5, 5)
			array [0] := data_1; array [1] := data_2; array [2] := data_3; array [3] := data_4

			from j := 0 until j = 5 loop
				n := array [j]
				inspect j + 1
					when 1 then
						start_index := 1; end_index := 8
					when 2 then
						start_index := 10; end_index := 13
					when 3 then
						start_index := 15; end_index := 18
					when 4 then
						start_index := 20; end_index := 23
					when 5 then
						start_index := 25; end_index := 36
				else
				end
				from i := end_index until i < start_index loop
					digit := n & Nibble_15_mask
					Result.put (digit.to_hex_character, i)
					n := n |>> 4
					i := i - 1
				end
				j := j + 1
			end
		ensure then
			result_is_valid_uuid: is_valid_uuid (Result)
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	Field_hash: NATURAL = 201719989

	Nibble_15_mask: NATURAL_64 = 0xF

	Ordered_alphabetically: BOOLEAN = True
		-- read/write fields in alphabetical order

end
