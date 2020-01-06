note
	description: "Xpath integer 64 setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_XPATH_INTEGER_64_SETTER

inherit
	EL_XPATH_VALUE_SETTER [INTEGER_64]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): INTEGER_64
		do
			Result := table.integer_64 (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): INTEGER_64
		do
			Result := node.integer_64_value
		end
end
