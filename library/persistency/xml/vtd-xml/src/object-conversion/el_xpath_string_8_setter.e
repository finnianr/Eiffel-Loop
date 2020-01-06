note
	description: "Xpath string 8 setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_XPATH_STRING_8_SETTER

inherit
	EL_XPATH_VALUE_SETTER [STRING]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): STRING
		do
			Result := table.string_8 (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): STRING
		do
			Result := node.normalized_string_8_value
		end
end
