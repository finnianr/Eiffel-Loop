note
	description: "Xpath integer 64 setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:09:39 GMT (Thursday 24th February 2022)"
	revision: "6"

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
			Result := node.as_integer_64
		end
end