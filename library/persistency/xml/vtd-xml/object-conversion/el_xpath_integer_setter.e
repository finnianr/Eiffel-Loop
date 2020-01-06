note
	description: "Xpath integer setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XPATH_INTEGER_SETTER

inherit
	EL_XPATH_VALUE_SETTER [INTEGER]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): INTEGER
		do
			Result := table.integer (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): INTEGER
		do
			Result := node.integer_value
		end
end
