note
	description: "Single path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 11:53:51 GMT (Monday 12th July 2021)"
	revision: "9"

deferred class
	EL_SINGLE_PATH_OPERAND_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			make_default
		end

	-- Use reflection to determine names of path argument fields
	EL_REFLECTIVE
		rename
			export_name as export_default,
			import_name as import_default,
			field_included as is_path_field
		export
			{NONE} all
		redefine
			Transient_fields
		end

	EL_SHARED_CLASS_ID

feature {NONE} -- Initialization

	make (a_path: like path)
			--
		do
			make_default
			path := a_path
		end

	make_default
		do
			path := Default_path
			Precursor
		end

feature -- Access

	path: like Default_path

feature -- Element change

	set_path (a_path: like path)
			--
		do
			path := a_path
		end

feature {NONE} -- Evolicity reflection

	get_escaped_path: ZSTRING
		do
			Result := path.escaped
		end

	getter_function_table: like getter_functions
			--
		local
			field_name: STRING
		do
			field_name := meta_data.field_list.first.name
			create Result.make (<< [field_name, agent get_escaped_path] >>)
		end

feature {NONE} -- Implementation

	is_path_field (basic_type, type_id: INTEGER): BOOLEAN
		-- when True, include field of this type in `field_table' and `meta_data'
		-- except when the name is one of those listed in `Except_fields'.
		do
			if basic_type = {REFLECTOR_CONSTANTS}.Reference_type then
				Result := Eiffel.type_conforms_to (type_id, Class_id.EL_PATH)
			end
		end

feature {NONE} -- Constants

	Default_path: EL_PATH
		once
			create {EL_DIR_PATH} Result
		end

	Transient_fields: STRING
		once
			Result := "output_path, template_path, working_directory"
		end

end