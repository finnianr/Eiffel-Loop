note
	description: "Summary description for {EL_XML_RECORD_OPERATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 14:17:57 GMT (Thursday 1st January 2015)"
	revision: "3"

deferred class
	EL_XML_ELEMENT_EDITION [STORABLE_TYPE -> EL_STORABLE_XML_ELEMENT]

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

	EL_MODULE_UTF

feature -- Access

	element: STORABLE_TYPE

	index: INTEGER

	tag_name: STRING
		local
			node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			create node.make_from_string (UTF.utf_32_string_to_utf_8_string_8 (Template))
			Result := node.name
		end

feature -- Status query

	has_element: BOOLEAN

feature -- Basic operations

	apply (target: LIST [STORABLE_TYPE])
			-- Apply record operation to target list
		deferred
		end

feature {NONE} -- Evolicity fields

	get_index: INTEGER_REF
			--
		do
			Result := index.to_reference
		end

	get_element: STORABLE_TYPE
			--
		do
			Result := element
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["index", agent get_index],
				["element", agent get_element]
			>>)
		end

end
