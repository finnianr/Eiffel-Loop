note
	description: "Single path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:51:17 GMT (Wednesday 1st September 2021)"
	revision: "10"

deferred class
	EL_SINGLE_PATH_OPERAND_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			make_default, getter_function_table, Transient_fields
		end

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
			Result := Precursor + [field_name, agent get_escaped_path]
		end

feature {NONE} -- Constants

	Default_path: EL_PATH
		once
			create {EL_DIR_PATH} Result
		end

	Transient_fields: STRING
		once
			Result := Precursor + ", output_path, template_path, working_directory"
		end

end