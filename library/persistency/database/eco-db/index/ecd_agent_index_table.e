note
	description: "[
		A field index conforming to ${ECD_INDEX_TABLE [EL_STORABLE, HASHABLE]} that uses
		an ${FUNCTION} agent `storable_key' to obtain the value of the indexed field.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "14"

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

	make (a_list: like list; a_storable_key: like storable_key)
		do
			storable_key := a_storable_key
			make_index (a_list)
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