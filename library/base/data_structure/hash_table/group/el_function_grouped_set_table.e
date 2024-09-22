note
	description: "[
		Table for grouping items of type `G' into sets of type ${EL_ARRAYED_LIST [G]} according to
		the result of applying a function agent of type ${FUNCTION [G, K]} where **K** conforms to
		${HASHABLE}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:58:32 GMT (Sunday 22nd September 2024)"
	revision: "17"

class
	EL_FUNCTION_GROUPED_SET_TABLE [G, K -> HASHABLE]

inherit
	EL_FUNCTION_GROUPED_LIST_TABLE [G, K]
		rename
			item_list as item_set,
			item_area_list as item_area_set,
			found_list as found_set,
			make_equal as make_equal_sized,
			wipe_out_lists as wipe_out_sets
		undefine
			is_set
		end

	EL_GROUPED_SET_TABLE [G, K]
		rename
			make_equal as make_equal_sized,
			make as make_sized
		end

create
	make, make_equal, make_from_list, make_equal_from_list

feature {NONE} -- Initialization

	make_equal (a_group_key: like group_key; n: INTEGER)
		do
			group_key := a_group_key
			make_equal_sized (n)
		end

	make_equal_from_list (a_group_key: FUNCTION [G, K]; a_list: ITERABLE [G])
		-- Group items `list' into groups defined by `a_group_key' function
		do
			make_equal (a_group_key, (Iterable.count (a_list) // 2).min (11))
			across a_list as list loop
				extend (a_group_key (list.item), list.item)
			end
		ensure
			each_item_in_group: across a_list as l_list all
				item_set (a_group_key (l_list.item)).has (l_list.item)
			end
		end

end