note
	description: "[
		An object providing fast sequential lookups of character code at a subarray index of an `area' belonging
		to an instance of ${EL_SUBSTRING_32_ARRAY}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_INDEXABLE_SUBSTRING_32_ARRAY

inherit
	EL_SUBSTRING_32_ARRAY_ITERATOR
		export
			{NONE} all
			{ANY} valid_index, start
		redefine
			offset, back, forth, start
		end

create
	default_create, make

feature {NONE} -- Initialization

	make (array: EL_SUBSTRING_32_ARRAY)
		do
			start (array.area)
		end

feature -- Access

	code alias "[]" (i: INTEGER): NATURAL
		require
			valid_index: valid_index (i)
		local
			l_area: like area; l_lower: INTEGER
		do
			l_area := area; l_lower := lower_bound (l_area, index)
			if i < l_lower then
				back
			--	Recurse
				Result := code (i)
			elseif i > upper_bound (l_area, index) then
				forth
			--	Recurse
				Result := code (i)
			else
				Result := l_area [offset + i - l_lower].natural_32_code
			end
		end

feature -- Element change

	start (a_area: like area)
		do
			Precursor (a_area)
			offset := index_final
		end

feature {NONE} -- Implementation

	back
		do
			index := index - 2
			offset := offset - character_count
		end

	forth
		do
			offset := offset + character_count
			index := index + 2
		end

feature {NONE} -- Internal attributes

	offset: INTEGER

end