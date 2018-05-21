note
	description: "Xpath boolean setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_XPATH_BOOLEAN_SETTER

inherit
	EL_XPATH_VALUE_SETTER [BOOLEAN]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := table.boolean (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): BOOLEAN
		do
			Result := node.boolean_value
		end

end
