note
	description: "Supporting class for class [$source ECD_PRIMARY_KEY_INDEXABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 15:30:08 GMT (Thursday 22nd February 2018)"
	revision: "3"

class
	ECD_KEY_INDEX [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

inherit
	ECD_LIST_INDEX [G, NATURAL]
		rename
			make as make_index
		redefine
			item_key
		end

create
	make

feature {NONE} -- Initialization

	make (a_list: like list; n: INTEGER)
		do
			make_index (a_list, agent item_key, n)
		end

feature {NONE} -- Implementation

	item_key (a_item: G): NATURAL
		do
			Result := a_item.key
		end

end
