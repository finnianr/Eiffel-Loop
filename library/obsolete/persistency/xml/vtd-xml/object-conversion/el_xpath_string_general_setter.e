note
	description: "Xpath string general setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:14:25 GMT (Thursday 24th February 2022)"
	revision: "2"

class
	EL_XPATH_STRING_GENERAL_SETTER

inherit
	EL_XPATH_VALUE_SETTER [READABLE_STRING_GENERAL]

feature {NONE} -- Implementation

	attribute_value (node: EL_XPATH_NODE_CONTEXT; name: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
		do
			Result := node [name].as_string_32
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): READABLE_STRING_GENERAL
		do
			Result := node.as_string_32
		end
end
