note
	description: "[
		Set of numeric constants mapped to names of type ${IMMUTABLE_STRING_8} with
		shared character data from single ${SPECIAL [CHARACTER]} array.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 12:53:16 GMT (Wednesday 29th May 2024)"
	revision: "2"

class
	EL_IMMUTABLE_NAME_TABLE [N -> {NUMERIC, HASHABLE}]

inherit
	EL_HASH_TABLE [IMMUTABLE_STRING_8, N]
		rename
			make as make_from_tuples
		end

create
	make, make_from_tuples

feature {NONE} -- Initialization

	make (n_set: ARRAY [N]; n_set_names: STRING_8)
		require
			name_count_matches: n_set.count = n_set_names.occurrences (',') + 1
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			make_size (n_set.count)
			name_list := n_set_names
			create split_list.make_shared_adjusted (n_set_names, ',', {EL_SIDE}.Left)
			across split_list as list until not n_set.valid_index (list.cursor_index) loop
				put (list.item, n_set [list.cursor_index])
				check
					no_conflict: inserted
				end
			end
		ensure
			full: count = n_set.count
		end

feature {NONE} -- Internal attributes

	name_list: STRING_8

end