note
	description: "Published book information reflectively settable from XML context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:06 GMT (Tuesday 18th March 2025)"
	revision: "15"

class
	EL_BOOK_INFO

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			element_node_fields as All_fields,
			xml_naming as kebab_case
		redefine
			make_default
		end

	EVC_REFLECTIVE_EIFFEL_CONTEXT
		rename
			getter_function_table as empty_function_table
		undefine
			is_equal
		redefine
			make_default
		end

	EVC_REFLECTIVE_XML_CONTEXT

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVC_REFLECTIVE_EIFFEL_CONTEXT}
		end

feature -- Access

	author: ZSTRING

	creator: ZSTRING

	description: ZSTRING

	language: STRING

	cover_image_path: FILE_PATH
		-- relative path of cover image

	publication_date: STRING

	publisher: ZSTRING

	subject_heading: ZSTRING

	title: ZSTRING

	uuid: STRING

end