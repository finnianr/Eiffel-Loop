note
	description: "Implementation of ${EL_FACTORY_POOL [G]} using a supplied agent to create new items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_AGENT_FACTORY_POOL [G]

inherit
	EL_FACTORY_POOL [G]
		rename
			make as make_pool
		end

create
	make

feature {NONE} -- Initialization

	make (size: INTEGER; a_new_item: like make_new_item)
		do
			make_new_item := a_new_item
			make_pool (size)
		end

feature {NONE} -- Implementation

	new_item: G
		do
			make_new_item.apply
			Result := make_new_item.last_result
		end

feature {NONE} -- Internal attributes

	make_new_item: FUNCTION [G]

end