note
	description: "Xpath natural 64 setter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_XPATH_NATURAL_64_SETTER

inherit
	EL_XPATH_VALUE_SETTER [NATURAL_64]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): NATURAL_64
		do
			Result := table.natural_64 (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): NATURAL_64
		do
			Result := node.natural_64_value
		end
end
