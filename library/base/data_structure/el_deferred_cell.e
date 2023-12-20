note
	description: "A data cell with deferred initialization of the item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 19:33:27 GMT (Wednesday 20th December 2023)"
	revision: "6"

class
	EL_DEFERRED_CELL [G]

inherit
	EL_LAZY_ATTRIBUTE

create
	make

feature {NONE} -- Initialization

	make (a_item_factory: like item_factory)
		do
			item_factory := a_item_factory
		end

feature -- Element change

	update
		do
			actual_item := new_item
		end

feature {NONE} -- Implementation

	new_item: G
		do
			item_factory.apply
			Result := item_factory.last_result
		end

feature {NONE} -- Internal attributes

	item_factory: FUNCTION [G]
end