note
	description: "[
		A field index conforming to [$source ECD_INDEX_TABLE [EL_STORABLE, HASHABLE]] that uses
		an [$source FUNCTION] agent `storable_key' to obtain the value of the indexed field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 13:11:50 GMT (Monday 24th May 2021)"
	revision: "11"

class
	ECD_AGENT_INDEX_TABLE [G -> EL_STORABLE create make_default end, K -> detachable HASHABLE]

inherit
	ECD_INDEX_TABLE [G, K]
		rename
			make as make_index
		end

create
	make

feature {NONE} -- Initialization

	make (a_list: like list; a_storable_key: like storable_key; n: INTEGER)
		do
			storable_key := a_storable_key
			make_index (a_list, n)
		end

feature {NONE} -- Implementation

	item_key (v: G): K
		-- allows possibility to call `a_item.key' directly in `ECD_KEY_INDEX' descendant
		do
			Result := storable_key (v)
		end

feature {NONE} -- Internal attributes

	storable_key: FUNCTION [G, K]

end