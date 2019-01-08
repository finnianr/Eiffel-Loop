note
	description: "File info for manifest list [$source EL_FILE_MANIFEST_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-08 22:21:41 GMT (Tuesday 8th January 2019)"
	revision: "3"

class
	EL_FILE_MANIFEST_ITEM

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

	EVOLICITY_REFLECTIVE_XML_CONTEXT
		undefine
			is_equal
		end

	COMPARABLE
		undefine
			is_equal
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
		do
			make_default
			name := file_path.base
			if file_path.exists then
				byte_count := File_system.file_byte_count (file_path)
				modification_time := file_path.modification_time
			end
		end

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT}
		end

feature -- Access

	byte_count: INTEGER

	modification_time: INTEGER

	name: ZSTRING

	set_name (a_name: ZSTRING)
		do
			name := a_name
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if Current /= other then
				Result := name < other.name
			end
		end

end
