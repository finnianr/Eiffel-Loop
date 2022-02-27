note
	description: "Xpath double setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-24 18:12:30 GMT (Thursday 24th February 2022)"
	revision: "6"

class
	EL_XPATH_DOUBLE_SETTER

inherit
	EL_XPATH_VALUE_SETTER [DOUBLE]

feature {NONE} -- Implementation

	attribute_value (node: EL_XPATH_NODE_CONTEXT; name: READABLE_STRING_GENERAL): DOUBLE
		do
			Result := node [name]
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): DOUBLE
		do
			Result := node
		end

end
