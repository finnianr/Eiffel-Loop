note
	description: "${EL_CACHE_TABLE} with `new_item' calling a supplied agent function"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 15:46:17 GMT (Sunday 22nd September 2024)"
	revision: "13"

class
	EL_AGENT_CACHE_TABLE [G, K -> HASHABLE]

inherit
	EL_CACHE_TABLE [G, K]
		rename
			make as make_sized,
			make_equal as make_equal_sized
		end

create
	make, make_equal

feature {NONE} -- Initialization

	make (n: INTEGER; a_new_item: like new_item_agent)
		do
			make_sized (n)
			new_item_agent := a_new_item
		end

	make_equal (n: INTEGER; a_new_item: like new_item_agent)
		do
			make (n, a_new_item)
			compare_objects
		end

feature -- Element change

	set_new_item (a_new_item: like new_item_agent)
		do
			new_item_agent := a_new_item
		end

	set_new_item_target (target: ANY)
		do
			new_item_agent.set_target (target)
		end

feature {NONE} -- Implementation

	new_item (key: K): G
		do
			Result := new_item_agent (key)
		end

feature {NONE} -- Internal attributes

	new_item_agent: FUNCTION [K, G]

end