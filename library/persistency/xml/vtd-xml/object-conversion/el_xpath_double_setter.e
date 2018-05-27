note
	description: "Xpath double setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "5"

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

