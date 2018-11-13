note
	description: "File info for manifest list [$source EL_FILE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 11:48:06 GMT (Tuesday 13th November 2018)"
	revision: "1"

class
	EL_FILE_MANIFEST_ITEM

inherit
	EL_REFLECTIVE
		rename
			field_included as is_field_convertable_from_string,
			export_name as to_kebab_case,
			import_name as import_default
		redefine
			Except_fields
		end

	EVOLICITY_REFLECTIVE_SERIALIZEABLE
		rename
			getter_function_table as empty_function_table,
			template as XML_element_list_template
		end

	EVOLICITY_REFLECTIVE_XML_CONTEXT

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (file_path: EL_FILE_PATH)
		do
			name := file_path.base
			if file_path.exists then
				byte_count := File_system.file_byte_count (file_path)
				modification_time := file_path.modification_time
			end
			make_default
		end

feature -- Access

	byte_count: INTEGER

	modification_time: INTEGER

	name: ZSTRING

feature {NONE} -- Constants

	Except_fields: STRING = "internal_encoding, template_path, output_path"

end
