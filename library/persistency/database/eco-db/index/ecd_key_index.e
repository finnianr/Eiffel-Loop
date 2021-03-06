note
	description: "[
		A field index conforming to [$source ECD_INDEX_TABLE [EL_STORABLE, HASHABLE]] that indexes
		a primary key of type [$source NATURAL_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 13:13:14 GMT (Monday 24th May 2021)"
	revision: "6"

class
	ECD_KEY_INDEX [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

inherit
	ECD_INDEX_TABLE [G, NATURAL]

create
	make

feature {NONE} -- Implementation

	item_key (a_item: G): NATURAL
		do
			Result := a_item.key
		end

end