note
	description: "A cell with deferred initialization of the item"
	notes: "[
		Originally introduced as workaround for segmentation fault caused by using following once-per-object
		attribute in class [$source EL_CREATEABLE_FROM_NODE_SCAN] and others.
		
			node_source: EL_XML_NODE_SCAN_SOURCE
				once ("OBJECT")
					Result := new_node_source
				end


	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 19:24:47 GMT (Thursday 30th January 2020)"
	revision: "2"

class
	EL_DEFERRED_CELL [G]

create
	make

feature {NONE} -- Initialization

	make (a_new_item: like new_item)
		do
			new_item := a_new_item
		end

feature -- Access

	item: G
		do
			if attached actual_item as actual then
				Result := actual
			else
				new_item.apply
				Result := new_item.last_result
				actual_item := Result
			end
		end

feature {NONE} -- Internal attributes

	actual_item: detachable G

	new_item: FUNCTION [G]
end
