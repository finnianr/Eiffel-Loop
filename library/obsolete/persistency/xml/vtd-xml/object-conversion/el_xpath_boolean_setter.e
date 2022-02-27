note
	description: "Xpath boolean setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:08:57 GMT (Thursday 24th February 2022)"
	revision: "6"

class
	EL_XPATH_BOOLEAN_SETTER

inherit
	EL_XPATH_VALUE_SETTER [BOOLEAN]

feature {NONE} -- Implementation

	attribute_value (node: EL_XPATH_NODE_CONTEXT; name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := node [name]
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): BOOLEAN
		do
			Result := node
		end

end
