note
	description: "Format routines for ${INTEGER_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:39 GMT (Monday 25th December 2023)"
	revision: "7"

class
	EL_FORMAT_ROUTINES

inherit
	ANY; EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create format_table.make_equal (5, agent new_format)
		end

feature -- Real formatting

	double (d: DOUBLE; width, decimals: INTEGER): STRING
		do
			Result := double_string (d, width, decimals)
		end

	padded_double (d: DOUBLE; decimals: INTEGER): STRING
		do
			Result := double_string (d, decimals, decimals)
		end

feature -- Integer formatting

	integer (n: INTEGER): STRING
		do
			Result := integer_string (n, 1, False)
		end

	percentage (proportion: DOUBLE): STRING
		do
			Result := percent ((proportion * 100).rounded)
		end

	percent (n: INTEGER): STRING
		do
			Result := integer_string (n, 1, False) + char ('%%')
		end

	padded_integer (n, width: INTEGER): STRING
		do
			Result := integer_string (n, width, False)
		end

	zero_padded_integer (n, width: INTEGER): STRING
		-- zero padded integer
		do
			Result := integer_string (n, width, True)
		end

	padded_percentage (proportion: DOUBLE; width: INTEGER): STRING
		do
			Result := padded_percent ((proportion * 100).rounded, width)
		end

	padded_percent (n, width: INTEGER): STRING
		do
			Result := integer_string (n, width, False) + char ('%%')
		end

feature {NONE} -- Implementation

	double_string (d: DOUBLE; width, decimals: INTEGER): STRING
		local
			key: INTEGER; i32: EL_INTEGER_32_BIT_ROUTINES
		do
			key := i32.inserted (key, Is_real_mask, 1)
			key := i32.inserted (key, Width_mask, width)
			key := i32.inserted (key, Decimal_count_mask, decimals)

			if attached {FORMAT_DOUBLE} format_table.item (key) as format then
				Result := format.formatted (d)
			else
				create Result.make_empty
			end
		end

	integer_string (n, width: INTEGER; zero_padded: BOOLEAN): STRING
		local
			key: INTEGER; i32: EL_INTEGER_32_BIT_ROUTINES
		do
			key := i32.inserted (key, Zero_padded_mask, zero_padded.to_integer)
			key := i32.inserted (key, Width_mask, width)

			Result := format_table.item (key).formatted (n)
		end

	new_format (key: INTEGER): FORMAT_INTEGER
		local
			width, decimal_count: INTEGER; i32: EL_INTEGER_32_BIT_ROUTINES
			zero_padded: BOOLEAN; is_real: BOOLEAN
		do
			width := i32.isolated (key, Width_mask)
			decimal_count := i32.isolated (key, Decimal_count_mask)
			zero_padded := i32.isolated (key, Zero_padded_mask).to_boolean
			is_real := i32.isolated (key, Is_real_mask).to_boolean

			if is_real then
				create {FORMAT_DOUBLE} Result.make (width, decimal_count)
			else
				create Result.make (width)
			end

			if zero_padded then
				Result.zero_fill
			end
		end

feature {NONE} -- Internal attributes

	format_table: EL_AGENT_CACHE_TABLE [FORMAT_INTEGER, INTEGER]

feature {NONE} -- Constants

	Zero_padded_mask: INTEGER = 1

	Is_real_mask: INTEGER = 2

	Decimal_count_mask: INTEGER = 0xFFF0

	Width_mask: INTEGER = 0xFFF_0000

end