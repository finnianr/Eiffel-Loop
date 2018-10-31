note
	description: "Published book information reflectively settable from XML context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:23:59 GMT (Wednesday 31st October 2018)"
	revision: "3"

class
	EL_BOOK_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			xml_names as to_kebab_case,
			element_node_type as	Text_element_node
		redefine
			make_default
		end

	EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT
		rename
			getter_function_table as empty_function_table
		undefine
			is_equal
		redefine
			make_default
		end

	EVOLICITY_XML_ESCAPED_CONTEXT
		undefine
			is_equal
		end

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT}
		end

feature -- Access

	author: ZSTRING

	creator: ZSTRING

	description: ZSTRING

	language: STRING

	publication_date: STRING

	publisher: ZSTRING

	subject_heading: ZSTRING

	title: ZSTRING

	uuid: STRING

end
