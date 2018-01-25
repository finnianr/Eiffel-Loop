note
	description: "Summary description for {EL_STORABLE_KEY_INDEX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-26 10:05:26 GMT (Tuesday 26th December 2017)"
	revision: "2"

class
	EL_STORABLE_KEY_INDEX [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

inherit
	EL_STORABLE_LIST_INDEX [G, NATURAL]
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
