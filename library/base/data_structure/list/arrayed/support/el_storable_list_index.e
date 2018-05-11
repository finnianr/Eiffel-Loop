note
	description: "Summary description for {EL_STORABLE_LIST_INDEX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-20 11:47:33 GMT (Tuesday 20th February 2018)"
	revision: "3"

class
	EL_STORABLE_LIST_INDEX [G -> EL_STORABLE create make_default end, K -> detachable HASHABLE]

inherit
	HASH_TABLE [INTEGER, K]
		rename
			make as make_count,
			found_item as found_index,
			has as has_index
		export
			{NONE} all
			{EL_STORABLE_LIST} wipe_out
			{ANY} found, found_index, has_key
		redefine
			search
		end

create
	make

feature {NONE} -- Initialization

	make (a_list: like list; a_storable_key: like storable_key; n: INTEGER)
		do
			list := a_list; storable_key := a_storable_key
			make_equal (n)
			create key_argument
			storable_key.set_operands (key_argument)
			create default_found_item.make_default
			found_item := default_found_item
		end

feature -- Access

	found_item: G

feature -- Status query

	has (a_item: G): BOOLEAN
		do
			Result := has_key (item_key (a_item))
		end

feature -- Basic operations

	search (key: K)
		do
			if has_key (key) and then list.valid_index (found_index) then
				found_item := list [found_index]
			else
				found_item := default_found_item
			end
		end

	list_search (key: K)
		do
			search (key)
			if found and list.valid_index (found_index) then
				list.go_i_th (found_index)
			else
				list.finish; list.forth
			end
		end

feature {EL_STORABLE_LIST} -- Access

	list: EL_STORABLE_LIST [G]

feature {EL_STORABLE_LIST} -- Event handlers

	on_delete (a_item: G)
		do
			remove (item_key (a_item))
		end

	on_extend (a_item: G)
		do
			put (list.count, item_key (a_item))
		ensure
			no_conflict: not conflict
		end

	on_replace (new_item: G)
		require
			cursor_on_item: not list.off
		local
			old_key: K
		do
			old_key := item_key (list.item)
			force (list.index, item_key (new_item))
			if not_found then
				remove (old_key)
			end
		end

feature {NONE} -- Implementation

	item_key (v: G): K
		do
			key_argument.storable := list.last
			storable_key.apply
			Result := storable_key.last_result
		end

feature {NONE} -- Internal attributes

	key_argument: TUPLE [storable: G]

	storable_key: FUNCTION [G, K]

	default_found_item: G

end
