note
	description: "Summary description for {EL_XPATH_ZSTRING_SETTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 10:29:39 GMT (Tuesday 18th April 2017)"
	revision: "1"

class
	EL_XPATH_ZSTRING_SETTER

inherit
	EL_XPATH_VALUE_SETTER [ZSTRING]

feature {NONE} -- Implementation

	attribute_value (table: EL_ELEMENT_ATTRIBUTE_TABLE; name: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := table.string (name)
		end

	node_value (node: EL_XPATH_NODE_CONTEXT): ZSTRING
		do
			Result := node.normalized_string_value
		end
end
