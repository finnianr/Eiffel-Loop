note
	description: "[
		A field index for Eco-DB arrayed lists conforming to [$source ECD_ARRAYED_LIST [EL_STORABLE]]
	]"
	notes: "[
		The index is only maintend for field values that are unique. 
		If the field value is an empty string then the data item of type `G' is excluded
		from being deleted, extended or replaced.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-28 18:20:17 GMT (Sunday 28th February 2021)"
	revision: "10"

class
	ECD_LIST_INDEX [G -> EL_STORABLE create make_default end, K -> detachable HASHABLE]

inherit
	HASH_TABLE [INTEGER, K]
		rename
			make as make_count,
			found_item as found_index,
			has as has_index
		export
			{NONE} all
			{ECD_ARRAYED_LIST} wipe_out
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

feature {ECD_ARRAYED_LIST} -- Access

	list: ECD_ARRAYED_LIST [G]

feature {ECD_ARRAYED_LIST} -- Event handlers

	on_delete (a_item: G)
		local
			key: like item_key
		do
			key := item_key (a_item)
			if not key_is_empty (key) then
				remove (key)
			end
		end

	on_extend (a_item: G)
		local
			key: like item_key
		do
			key := item_key (a_item)
			if not key_is_empty (key)then
				put (list.count, key)
			end
		ensure
			no_conflict: not conflict
		end

	on_replace (new_item: G)
		require
			cursor_on_item: not list.off
		local
			old_key, new_key: K
		do
			old_key := item_key (list.item)
			if not key_is_empty (old_key) then
				remove (old_key)
			end
			new_key := item_key (new_item)
			if not key_is_empty (new_key) then
				extend (list.index, new_key)
			end
		end

feature {NONE} -- Implementation

	key_is_empty (key: like item_key): BOOLEAN
		do
			if attached {READABLE_STRING_GENERAL} key as key_string then
				Result := key_string.is_empty
			end
		end

	item_key (v: G): K
		-- allows possibility to call `a_item.key' directly in `ECD_KEY_INDEX' descendant
		do
			Result := storable_key (v)
		end

feature {NONE} -- Internal attributes

	storable_key: FUNCTION [G, K]

	default_found_item: G

end