note
	description: "Xpath string 32 setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:14:25 GMT (Thursday 24th February 2022)"
	revision: "6"

class
	EL_XPATH_STRING_32_SETTER

inherit
	EL_XPATH_VALUE_SETTER [STRING_32]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): STRING_32
		do
			Result := table.string_32 (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): STRING_32
		do
			Result := node.as_string_32
		end
end