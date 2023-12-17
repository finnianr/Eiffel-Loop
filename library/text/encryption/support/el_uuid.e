note
	description: "Universally unique identifier"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-17 10:45:18 GMT (Sunday 17th December 2023)"
	revision: "28"

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
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		undefine
			out
		redefine
			new_field_sorter
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_string
		undefine
			out, is_equal
		end

create
	make_default, make, make_from_string_general, make_from_string, make_from_array, make_from_other

convert
--	from
	make_from_other ({UUID}), make_from_string ({STRING}), make_from_string_general ({ZSTRING, STRING_32})

feature {NONE} -- Implementation

	make_from_other (other: UUID)
		do
			make (other.data_1, other.data_2, other.data_3, other.data_4, other.data_5)
		end

	make_from_string (str: STRING)
		do
			make_from_string_general (str)
		end

feature -- Access

	to_7_character_code: STRING
		-- trailing 35 bits of `data_5' represented as uppercase base 32 number
		-- (Approx 34.36 billion permutations)
		local
			data: NATURAL_64; i, quintet: INTEGER
		do
			create Result.make_filled (' ', 7)
			data := data_5
			from until i > 6 loop
				quintet := (data & Quintet_mask).to_integer_32
				inspect quintet
					when 0 .. 9 then
						Result [7 - i] := '0' + quintet
					when 10 .. 31 then
						Result [7 - i] := 'A' + (quintet - 10)
				end
				data := data |>> 5
				i := i + 1
			end
		ensure
			size_is_7: Result.count = 7
			equal_to_trailing_35_bits_of_data_5: base_32_as_integer_64 (Result) = data_5 & Thirty_five_bit_mask
		end

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
					digit := n & F_value_mask
					Result.put (digit.to_hex_character, i)
					n := n |>> 4
					i := i - 1
				end
				j := j + 1
			end
		ensure then
			result_is_valid_uuid: is_valid_uuid (Result)
		end

feature -- Contract Support

	base_32_as_integer_64 (code: STRING): NATURAL_64
		local
			converter: EL_BASE_32_CONVERTER
		do
			Result := converter.to_natural_64 (code)
		end

feature {NONE} -- Implementation

	new_field_sorter: like Default_field_order
		-- read/write fields in alphabetical order
		do
			create Result.make_default
			Result.set_alphabetical_sort
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	F_value_mask: NATURAL_64 = 0xF

	Field_hash: NATURAL = 201719989

	Quintet_mask: NATURAL_64 = 0x1F

	Thirty_five_bit_mask: NATURAL_64 = 0x7FFFFFFFF

end