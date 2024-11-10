note
	description: "A data cell with deferred initialization of the item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:28:27 GMT (Sunday 10th November 2024)"
	revision: "7"

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

feature -- Access

	item: like new_item
		do
			Result := lazy_item
		end

feature -- Element change

	update
		do
			cached_item := new_item
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