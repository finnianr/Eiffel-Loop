note
	description: "[
		Stateless character iteration over ${SPECIAL} area in ${EL_COMPACT_SUBSTRINGS_32}
	]"
	notes: "[
		For performance efficiency state is mantained externally in a local ${INTEGER_32} variable.
		The state is referenced by the routine argument `block_index_ptr: POINTER'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 7:20:00 GMT (Saturday 19th April 2025)"
	revision: "15"

expanded class
	EL_COMPACT_SUBSTRINGS_32_ITERATION

inherit
	EL_TYPED_POINTER_ROUTINES_I

	EL_ZCODE_CONVERSION

	EL_SHARED_IMMUTABLE_32_MANAGER

feature -- Access

	code (block_index_ptr: TYPED_POINTER [INTEGER]; area: SPECIAL [CHARACTER_32]; i: INTEGER): NATURAL
		do
			Result := item (block_index_ptr, area, i).natural_32_code
		end

	i_th_z_code (
		block_index_ptr: TYPED_POINTER [INTEGER]; area: SPECIAL [CHARACTER]
		unencoded_area: SPECIAL [CHARACTER_32]; i: INTEGER
	): NATURAL
		local
			c_i: CHARACTER
		do
			c_i := area [i]
			inspect c_i
				when Substitute then
					Result := item (block_index_ptr, unencoded_area, i + 1).natural_32_code
					Result := unicode_to_z_code (Result)
			else
				Result := c_i.natural_32_code
			end
		end

	index_of (
		block_index_ptr: TYPED_POINTER [INTEGER]; area: SPECIAL [CHARACTER_32]; uc: CHARACTER_32; start_index: INTEGER
	): INTEGER
		-- index of `unicode' starting from `start_index'
		local
			lower, upper, i, j: INTEGER; found: BOOLEAN
		do
			i := read_integer_32 (block_index_ptr)
			lower := area [i].code
			if start_index < lower then
				put_integer_32 (0, block_index_ptr)
				i := 0
			end
			from until found or else i = area.count loop
				upper := area [i + 1].code
				if start_index <= upper then
					found := True
				else
					i := i + upper - area [i].code + 3
				end
			end
			if found then
				from until Result > 0 or else i = area.count loop
					lower := area [i].code; upper := area [i + 1].code
					from j := lower.max (start_index) until Result > 0 or else j > upper loop
						if area [i + 2 + j - lower] = uc then
							Result := j
						end
						j := j + 1
					end
					if Result = 0 then
						i := i + upper - lower + 3
					end
				end
				if i = area.count then
					put_integer_32 (0, block_index_ptr)
				else
					put_integer_32 (i, block_index_ptr)
				end
			end
		ensure
			valid_result: Result > 0 implies item (block_index_ptr, area, Result) = uc
		end

	item (block_index_ptr: TYPED_POINTER [INTEGER]; area: SPECIAL [CHARACTER_32]; index: INTEGER): CHARACTER_32
		require
			at_least_one_block: area.count >= 3
		local
			i, lower, upper, block_index: INTEGER; found: BOOLEAN
		do
			block_index := read_integer_32 (block_index_ptr)
			lower := area [block_index].code
--			reset to beginning if `index' is prior to current block
			if index < lower then
				block_index := 0
				lower := area [block_index].code
			end
			upper := area [block_index + 1].code
			if index > upper then
				i := block_index + upper - lower + 3
				from until found or else i = area.count loop
					lower := area [i].code; upper := area [i + 1].code
					if lower <= index and index <= upper then
						block_index := i
						found := True
					else
						i := i + upper - lower + 3
					end
				end
--				write new block index back to calling routine local
				put_integer_32 (block_index, block_index_ptr)
			end
			Result := area [block_index + 2 + index - lower]
		end

	block_string (block_index: INTEGER; area: SPECIAL [CHARACTER_32]): IMMUTABLE_STRING_32
		-- Shared sub string from `area' at block index pointed to by  `block_index_ptr',
		-- Returns empty string if block index out of bounds of `area'
		require
			at_least_one_block: area.count >= 3
		local
			count, lower, upper: INTEGER
		do
			if block_index >= area.count then
				create Result.make_empty
			else
				lower := area [block_index].code
				upper := area [block_index + 1].code
				count := upper - lower + 1
				Immutable_32.set_item (area, block_index + 2, count)
				Result := Immutable_32.item
			end
		end

	next_index (block_index: INTEGER; str: IMMUTABLE_STRING_32): INTEGER
		-- next `block_index' for string returned by `block_string'
		do
			Result := block_index + 2 + str.count
		end

feature -- Comparison

	same_caseless_characters (
		block_index_ptr: TYPED_POINTER [INTEGER]; area, other_area: SPECIAL [CHARACTER_32]
		i, other_i, comparison_count: INTEGER
	): BOOLEAN
		local
			lower, block_index: INTEGER; c32: EL_CHARACTER_32_ROUTINES
		do
		--	`block_index_ptr' is set as side effect of calling `item'
			if c32.to_lower (item (block_index_ptr, area, i)) = c32.to_lower (other_area [other_i]) then
				block_index := read_integer_32 (block_index_ptr)
				lower := area [block_index].code
				Result := c32.same_caseless_sub_array (
					area, other_area, block_index + 2 + i - lower, other_i, comparison_count
				)
			end
		end

	same_characters (
		block_index_ptr: TYPED_POINTER [INTEGER]; area, other_area: SPECIAL [CHARACTER_32]
		i, other_i, comparison_count: INTEGER

	): BOOLEAN
		local
			block_index, lower: INTEGER
		do
		--	`block_index_ptr' is set as side effect of calling `item'
			if item (block_index_ptr, area, i) = other_area [other_i] then
				block_index := read_integer_32 (block_index_ptr)
				lower := area [block_index].code
				Result := area.same_items (other_area, other_i, block_index + 2 + i - lower, comparison_count)
			end
		end

feature -- Contract Support

	block_has (area: SPECIAL [CHARACTER_32]; block_index, index: INTEGER): BOOLEAN
		-- `True' if `index' is inside the substring interval referenced by `block_index_ptr'
		require
			area_has_at_least_one_block: area.count >= 3
		local
			upper, lower: INTEGER
		do
			lower := area [block_index].code; upper := area [block_index + 1].code
			Result := lower <= index and index <= upper
		end

feature -- Basic operations

	put (area: SPECIAL [CHARACTER_32]; uc: CHARACTER_32; block_index, index: INTEGER)
		-- set character at `index' in block referenced by `block_index_ptr'
		require
			valid_block_reference: block_has (area, block_index, index)
		local
			lower: INTEGER
		do
			lower := area [block_index].code
			area [block_index + 2 + index - lower] := uc
		ensure
			character_set: item ($block_index, area, index) = uc
		end

end