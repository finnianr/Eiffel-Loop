note
	description: "Xpath real setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:16:30 GMT (Thursday 24th February 2022)"
	revision: "6"

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
			Result := node.as_real
		end

end
