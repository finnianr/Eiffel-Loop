note
	description: "Efficient iteration over [$source SPECIAL] area of [$source EL_UNENCODED_CHARACTERS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-21 15:20:36 GMT (Tuesday 21st February 2023)"
	revision: "1"

expanded class
	EL_UNENCODED_CHARACTER_ITERATION

inherit
	EL_POINTER_ROUTINES
		export
			{NONE} all
		end

feature -- Access

	item (integer_32_block_index_ptr: POINTER; area: SPECIAL [CHARACTER_32]; index: INTEGER): CHARACTER_32
		local
			i, lower, upper, block_index: INTEGER; found: BOOLEAN
		do
			block_index := read_integer_32 (integer_32_block_index_ptr)
			lower := area [block_index].code
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
				put_integer_32 (block_index, integer_32_block_index_ptr)
			end
			Result := area [block_index + 2 + index - lower]
		end

end