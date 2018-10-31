note
	description: "General purpose OS command using an externally supplied template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:40:57 GMT (Wednesday 31st October 2018)"
	revision: "6"

class
	EL_OS_COMMAND

inherit
	EL_OS_COMMAND_I
		redefine
			template_name, new_temporary_name, temporary_error_file_path
		end

	EL_OS_COMMAND_IMP
		redefine
			template_name, new_temporary_name, temporary_error_file_path
		end

	EL_REFLECTION_HANDLER

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_template: like template)
			--
		do
			make_with_name (a_template.substring (1, a_template.index_of (' ', 1) - 1), a_template)
		end

	make_with_name (name: READABLE_STRING_GENERAL; a_template: like template)
		do
			template := a_template
			template_name := name_template #$ [generating_type, name]
			make_default
		end

feature -- Element change

	put_directory_path (variable_name: STRING; a_dir_path: EL_DIR_PATH)
		do
			put_path (variable_name, a_dir_path)
		end

	put_file_path (variable_name: STRING; a_file_path: EL_FILE_PATH)
		do
			put_path (variable_name, a_file_path)
		end

	put_object (object: EL_REFLECTIVE)
		local
			table: EL_REFLECTED_FIELD_TABLE; field: EL_REFLECTED_FIELD
		do
			table := object.field_table
			from table.start until table.after loop
				field := table.item_for_iteration
				if variable_in_template (field.name) then
					if attached {EL_REFLECTED_PATH} field as path_field then
						put_path (field.name, path_field.value (object))
					else
						getter_functions [field.name] := agent get_context_item (field.to_string (object))
					end
				end
				table.forth
			end
		end

	put_path (variable_name: STRING; a_path: EL_PATH)
		do
			getter_functions [variable_name] := agent escaped_path (a_path)
		end

feature {NONE} -- Implementation

	variable_in_template (name: STRING): BOOLEAN
		local
			name_pos: INTEGER
		do
			name_pos := template.substring_index (name, 1)
			if name_pos > 1 then
				inspect template [name_pos - 1]
					when '$' then
						Result := True
					when '{' then
						Result := name_pos > 2
							and then name_pos + name.count <= template.count
							and then template [name_pos - 2] = '$'
							and then template [name_pos + name.count] = '}'
				else end
			end
		end

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.escaped
		end

	new_temporary_name: ZSTRING
		do
			Result := template_name.base
		end

	template: READABLE_STRING_GENERAL

	template_name: EL_FILE_PATH

	temporary_error_file_path: EL_FILE_PATH
		do
			Result := new_temporary_file_path ("err")
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "{%S}.%S"
		end

end
