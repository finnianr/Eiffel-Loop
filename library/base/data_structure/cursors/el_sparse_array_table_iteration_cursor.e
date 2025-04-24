note
	description: "[
		Iteration cursor for ${EL_SPARSE_ARRAY_TABLE [ANY, HASHABLE]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-24 6:11:09 GMT (Thursday 24th April 2025)"
	revision: "2"

class
	EL_SPARSE_ARRAY_TABLE_ITERATION_CURSOR [G, K -> HASHABLE]

inherit
	EL_HASH_TABLE_ITERATION_CURSOR [G, K]
		redefine
			key, make, target
		end

create
	make

feature {NONE} -- Initialization

	make (t: like target)
		do
			Precursor (t)
			is_array_indexed := t.is_array_indexed
			index_lower := t.index_lower
		end

feature -- Access

	key: K
		-- Key at current cursor position
		do
			if is_array_indexed then
				Result := target.index_to_key (positions_array [position_index] + index_lower)
			else
				Result := Precursor
			end
		end

feature -- Status query

	is_array_indexed: BOOLEAN

feature {NONE} -- Internal attributes

	index_lower: INTEGER

	target: EL_SPARSE_ARRAY_TABLE [G, K]
end