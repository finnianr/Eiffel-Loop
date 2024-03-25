note
	description: "General purpose OS command using an externally supplied template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-25 10:41:10 GMT (Monday 25th March 2024)"
	revision: "27"

class
	EL_OS_COMMAND

inherit
	EL_OS_COMMAND_I
		rename
			template as Empty_string
		export
			{ANY} put_any, put_string, put_integer, put_variables, put_double, put_natural, put_real
		redefine
			getter_function_table, has_variable, system_command, template_name,
			new_temporary_name, temporary_error_file_path, put_any
		end

	EL_OS_COMMAND_IMP
		rename
			template as Empty_string
		redefine
			has_variable, system_command, template_name, new_temporary_name,
			temporary_error_file_path, put_any
		end

	EL_REFLECTION_HANDLER

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
		local
			space_index: INTEGER
		do
			space_index := a_template.index_of (' ', 1)
			if space_index > 0 then
				make_with_name (a_template.substring (1, space_index - 1), a_template)
			else
				make_with_name (default_name (a_template), a_template)
			end
		end

	make_with_name (name, a_template: READABLE_STRING_GENERAL)
		do
			create template.make (a_template)
			set_template_name (name)
			make_default
		end

feature -- Status query

	has_variable (name: READABLE_STRING_8): BOOLEAN
		do
			Result:= template.has_variable (name)
		end

feature -- Element change

	put_object (object: EL_REFLECTIVE)
		local
			table: EL_FIELD_TABLE; field: EL_REFLECTED_FIELD
		do
			table := object.field_table
			from table.start until table.after loop
				field := table.item_for_iteration
				if template.has_variable (field.name) then
					if attached {EL_REFLECTED_PATH} field as path_field then
						template.set_variable (field.name, path_field.value (object).escaped)
					elseif attached {EL_REFLECTED_URI [EL_URI]} field as uri_field then
						template.set_variable (field.name, File_system.escaped_path (uri_field.value (object)))
					else
						template.set_variable (field.name, field.to_string (object))
					end
				end
				table.forth
			end
		end

	put_path (variable_name: READABLE_STRING_8; a_path: EL_PATH)
		do
			template.set_variable (variable_name, a_path.escaped)
		end

	put_uri (variable_name: READABLE_STRING_8; uri: EL_URI)
		require
			has_variable: has_variable (variable_name)
		do
			template.set_variable (variable_name, File_system.escaped_path (uri))
		end

	put_any (variable_name: READABLE_STRING_8; object: ANY)
		do
			if attached {EL_PATH} object as path then
				put_path (variable_name, path)
			else
				template.set_variable (variable_name, object)
			end
		end

feature -- Contract Support

	valid_tuple (var_names: TUPLE): BOOLEAN
		do
			if template.variables.count = var_names.count then
				Result := template.variables.for_all (agent {ZSTRING}.is_valid_as_string_8)
			end
		end

	all_string_8_types (var_names: TUPLE): BOOLEAN
		do
			Result := Tuple.type_array (var_names).is_uniformly ({STRING})
		end

feature -- Basic operations

	fill_variables (var_names: TUPLE)
		-- fill a tuple `TUPLE [x, y, z: ZSTRING]' with variable names in the order
		-- in which they occurr in template
		require
			all_string_8_types: all_string_8_types (var_names)
			valid_variable_tuple: valid_tuple (var_names)
		do
			across template.variables as name loop
				if var_names.valid_index (name.cursor_index) then
					var_names.put_reference (name.item.to_latin_1, name.cursor_index)
				end
			end
		end

feature {NONE} -- Implementation

	default_name (a_template: READABLE_STRING_GENERAL): ZSTRING
		local
			space_index: INTEGER
		do
			space_index := a_template.index_of (' ', 1)
			create Result.make (space_index.max (a_template.count))
			if space_index > 0 then
				Result.append_substring_general (a_template, 1, space_index - 1)
			else
				Result.append_string_general (a_template)
			end
		end

	new_temporary_name: ZSTRING
		do
			Result := template_name.base
		end

	system_command: ZSTRING
		do
			Result := template.substituted
		end

	set_template_name (name: READABLE_STRING_GENERAL)
		do
			template_name := name_template #$ [generator, name]
		end

	temporary_error_file_path: FILE_PATH
		do
			Result := new_temporary_file_path ("err")
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Internal attributes

	template: EL_ZSTRING_TEMPLATE

	template_name: FILE_PATH

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S.%S"
		end

end