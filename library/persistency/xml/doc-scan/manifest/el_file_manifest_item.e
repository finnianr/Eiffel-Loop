note
	description: "File info for manifest list ${EL_FILE_MANIFEST_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 10:13:21 GMT (Monday 3rd July 2023)"
	revision: "16"

class
	EL_FILE_MANIFEST_ITEM

inherit
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		rename
			field_included as is_any_field,
			element_node_fields as All_fields,
			xml_naming as kebab_case
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

	COMPARABLE
		undefine
			is_equal
		end

	EL_MODULE_FILE

create
	make, make_default, make_named

convert
	make_named ({STRING, STRING_32})

feature {NONE} -- Initialization

	make (file_path: FILE_PATH)
		do
			make_default
			name := file_path.base
			if file_path.exists then
				byte_count := File.byte_count (file_path)
				modification_time := file_path.modification_time
			end
		end

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_REFLECTIVE_EIFFEL_CONTEXT}
		end

	make_named (a_name: READABLE_STRING_GENERAL)
		do
			make_default
			create name.make_from_general (a_name)
		end

feature -- Access

	byte_count: INTEGER

	named_path_modification_time (location_dir: DIR_PATH): INTEGER
		do
			Result := (location_dir + name).modification_time
		end

	modification_time: INTEGER

	modificiation_date_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (modification_time)
		end

	name: ZSTRING

feature -- Element change

	set_byte_count (a_byte_count: like byte_count)
		do
			byte_count := a_byte_count
		end

	set_modification_time (a_modification_time: like modification_time)
		do
			modification_time := a_modification_time
		end

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