note
	description: "A data cell with deferred initialization of the item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-03 13:32:42 GMT (Monday 3rd August 2020)"
	revision: "3"

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
