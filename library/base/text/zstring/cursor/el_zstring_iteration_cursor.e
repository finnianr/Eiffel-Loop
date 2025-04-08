note
	description: "${CHARACTER_32} iterator for ${EL_READABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-07 7:04:24 GMT (Monday 7th April 2025)"
	revision: "39"

class
	EL_ZSTRING_ITERATION_CURSOR

inherit
	EL_STRING_ITERATION_CURSOR
		rename
			Unicode_table as Shared_unicode_table
		end

	STRING_32_ITERATION_CURSOR
		rename
			area as unencoded_area,
			area_first_index as index_lower,
			area_last_index as index_upper,
			make as set_target
		redefine
			item, set_target, target
		end

	EL_ZSTRING_CONSTANTS
		rename
			Empty_string as Empty_target
		end

	EL_32_BIT_IMPLEMENTATION

create
	make, make_empty

feature-- Element change

	set_target (a_target: EL_READABLE_ZSTRING)
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

	z_code: NATURAL
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

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		local
			i, i_final, l_block_index: INTEGER; c_i: CHARACTER; uc: CHARACTER_32
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; unicode: like codec.unicode_table
		do
			codec.decode (n, area, destination, 0)
			unicode := codec.unicode_table
			if attached area as l_area and then attached unencoded_area as area_32 then
				i_final := source_index + index_lower + n
				from i := source_index + index_lower until i = i_final loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc := iter.item ($l_block_index, area_32, i - index_lower + 1)
					else
						uc := unicode [c_i.code]
					end
					destination.extend (uc)
					i := i + 1
				end
			end
		end

feature -- Measurement

	target_count: INTEGER
		do
			Result := target.count
		end

feature {NONE} -- Implementation

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		local
			c8: EL_CHARACTER_8_ROUTINES
		do
			Result := c8.is_i_th_eiffel_identifier (a_area, i, case_code, first_i)
		end

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		do
			Result := i_th_character_32 (a_area, i).to_character_8
		end

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

	i_th_unicode (a_area: like area; i: INTEGER): NATURAL
		local
			c_i: CHARACTER
		do
			c_i := a_area [i]
			inspect character_8_band (c_i)
				when Substitute then
					Result := unencoded_item (i + 1).natural_32_code

				when Ascii_range then
					Result := c_i.natural_32_code
			else
				Result := Unicode_table [c_i.code].natural_32_code
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