note
	description: "Summary description for {EL_XPATH_DOUBLE_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 16:55:09 GMT (Tuesday 18th April 2017)"
	revision: "3"

class
	EL_XPATH_DOUBLE_SETTER

inherit
	EL_XPATH_VALUE_SETTER [DOUBLE]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): DOUBLE
		do
			Result := table.double (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): DOUBLE
		do
			Result := node.double_value
		end

end

