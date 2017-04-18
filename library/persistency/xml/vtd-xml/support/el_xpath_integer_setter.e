note
	description: "Summary description for {EL_XPATH_INTEGER_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 10:29:18 GMT (Tuesday 18th April 2017)"
	revision: "2"

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
