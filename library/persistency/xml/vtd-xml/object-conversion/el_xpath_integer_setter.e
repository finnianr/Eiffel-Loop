note
	description: "Xpath integer setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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
