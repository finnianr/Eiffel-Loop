note
	description: "[
		Set of numeric constants mapped to names of type ${IMMUTABLE_STRING_8} with
		shared character data from single ${SPECIAL [CHARACTER]} array.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 15:51:36 GMT (Wednesday 29th May 2024)"
	revision: "5"

class
	EL_IMMUTABLE_NAME_TABLE [N -> {NUMERIC, HASHABLE}]

inherit
	EL_HASH_TABLE [IMMUTABLE_STRING_8, N]
		rename
			make as make_from_tuples,
			current_keys as valid_keys
		export
			{NONE} put, force, extend
		redefine
			valid_keys
		end

create
	make

feature {NONE} -- Initialization

	make (a_valid_keys: ARRAY [N]; a_name_list: STRING_8)
		require
			name_count_matches: a_valid_keys.count = a_name_list.occurrences (',') + 1
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			make_size (a_valid_keys.count)
			valid_keys := a_valid_keys; internal_name_list := a_name_list
			create split_list.make_shared_adjusted (a_name_list, ',', {EL_SIDE}.Left)
			if attached split_list as list then
				from list.start until list.after or not a_valid_keys.valid_index (list.index) loop
					put (list.item, a_valid_keys [list.index])
					check
						unique_keys: inserted
					end
					list.forth
				end
			end
		ensure
			full: count = valid_keys.count
		end

feature -- Access

	valid_keys: ARRAY [N]

	name_list: STRING_8
		do
			Result := internal_name_list.twin
		end

feature {NONE} -- Internal attributes

	internal_name_list: STRING_8

end