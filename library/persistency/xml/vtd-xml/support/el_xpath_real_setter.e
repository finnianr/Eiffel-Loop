note
	description: "Summary description for {EL_XPATH_REAL_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 16:42:00 GMT (Tuesday 18th April 2017)"
	revision: "3"

class
	EL_XPATH_REAL_SETTER

inherit
	EL_XPATH_VALUE_SETTER [REAL]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): REAL
		do
			Result := table.real (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): REAL
		do
			Result := node.real_value
		end

end

