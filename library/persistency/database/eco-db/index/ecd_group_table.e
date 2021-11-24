note
	description: "[
		A field group index table for Eco-DB arrayed lists conforming to [$source ECD_ARRAYED_LIST [EL_STORABLE]]
		[$source EL_STORABLE] items are grouped according to the value of a specified agent of type FUNCTION [G, K]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 13:05:42 GMT (Wednesday 24th November 2021)"
	revision: "2"

class
	ECD_GROUP_TABLE [G -> EL_STORABLE, K -> HASHABLE]

inherit
	EL_FUNCTION_GROUP_TABLE [G, K]
		rename
			list_extend as on_extend,
			list_replace as on_replace,
			list_delete as on_delete,
			has as has_group_key
		end

	ECD_INDEX [G]
		undefine
			copy, is_equal
		end

create
	make

feature -- Status query

	has (a_item: G): BOOLEAN
		do
			Result := has_key (item_key (a_item)) and then found_list.has (a_item)
		end

end