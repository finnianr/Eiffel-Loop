note
	description: "Xpath string general setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-11 18:41:32 GMT (Wednesday 11th September 2019)"
	revision: "1"

class
	EL_XPATH_STRING_GENERAL_SETTER

inherit
	EL_XPATH_VALUE_SETTER [READABLE_STRING_GENERAL]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			Result := table.string_32 (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): READABLE_STRING_GENERAL
		do
			Result := node.normalized_string_32_value
		end
end
