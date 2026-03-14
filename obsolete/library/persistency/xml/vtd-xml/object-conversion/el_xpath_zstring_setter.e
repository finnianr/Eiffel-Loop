note
	description: "Xpath zstring setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:15:08 GMT (Thursday 24th February 2022)"
	revision: "5"

class
	EL_XPATH_ZSTRING_SETTER

inherit
	EL_XPATH_VALUE_SETTER [ZSTRING]

feature {NONE} -- Implementation

	attribute_value (node: EL_XPATH_NODE_CONTEXT; name: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := node [name]
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): ZSTRING
		do
			Result := node.as_string
		end
end
