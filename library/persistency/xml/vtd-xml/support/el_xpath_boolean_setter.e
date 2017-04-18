note
	description: "Summary description for {EL_XPATH_BOOLEAN_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 10:29:13 GMT (Tuesday 18th April 2017)"
	revision: "2"

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
