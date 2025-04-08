note
	description: "${CHARACTER_32} iterator for ${EL_READABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 16:09:30 GMT (Tuesday 8th April 2025)"
	revision: "40"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area,
			area_first_index as index_lower,
			area_last_index as index_upper
		redefine
			item, make, target
		end

	EL_SHARED_ZSTRING_CODEC
		rename
			Unicode_table as Shared_unicode_table
		end

	EL_ZCODE_CONVERSION

	EL_ZSTRING_CONSTANTS
		rename
			Empty_string as Empty_target
		end

	EL_32_BIT_IMPLEMENTATION

create
	make

feature -- Initialization

	make (a_target: EL_READABLE_ZSTRING)
		do
			Precursor (a_target)
			block_index := 0; area := a_target.area
			unicode_table := Shared_unicode_table
		end

feature -- Access

	item: CHARACTER_32
		do
			Result := i_th_character_32 (area, target_index - 1)
		end

	item_z_code: NATURAL
		local
			c_i: CHARACTER; i: INTEGER
		do
			i := target_index; c_i := area [i - 1]
			inspect c_i
				when Substitute then
					Result := unicode_to_z_code (unencoded_item (i).natural_32_code)
			else
				Result := c_i.natural_32_code
			end
		end

feature {NONE} -- Implementation

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		local
			c_i: CHARACTER
		do
			c_i := a_area [i]
			inspect character_8_band (c_i)
				when Substitute then
					Result := unencoded_item (i + 1)

				when Ascii_range then
					Result := c_i.to_character_32
			else
				Result := Unicode_table [c_i.code]
			end
		end

	unencoded_item (index: INTEGER): CHARACTER_32
		require
			at_least_one_block: unencoded_area.count >= 3
		local
			i, lower, upper: INTEGER; found: BOOLEAN
		do
			if attached unencoded_area as l_area then
				lower := l_area [block_index].code
	--			reset to beginning if `index' is prior to current block
				if index < lower then
					block_index := 0
					lower := l_area [block_index].code
				end
				upper := l_area [block_index + 1].code
				if index > upper then
					i := block_index + upper - lower + 3
					from until found or else i = l_area.count loop
						lower := l_area [i].code; upper := l_area [i + 1].code
						if lower <= index and index <= upper then
							block_index := i
							found := True
						else
							i := i + upper - lower + 3
						end
					end
				end
				Result := l_area [block_index + 2 + index - lower]
			end
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Internal attriutes

	area: SPECIAL [CHARACTER]

	block_index: INTEGER
		-- index into substring block contained in `unencoded_area'

	target: EL_READABLE_ZSTRING

	unicode_table: like codec.unicode_table

end