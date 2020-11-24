note
	description: "General purpose OS command using an externally supplied template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-24 13:41:47 GMT (Tuesday 24th November 2020)"
	revision: "10"

class
	EL_OS_COMMAND

inherit
	EL_OS_COMMAND_I
		rename
			template as Empty_string
		redefine
			has_variable, system_command, template_name, new_temporary_name, temporary_error_file_path, put_variable
		end

	EL_OS_COMMAND_IMP
		rename
			template as Empty_string
		redefine
			has_variable, system_command, template_name, new_temporary_name, temporary_error_file_path, put_variable
		end

	EL_REFLECTION_HANDLER

create
	make, make_with_name

feature {NONE} -- Initialization

	make (a_template: READABLE_STRING_GENERAL)
			--
		do
			make_with_name (a_template.substring (1, a_template.index_of (' ', 1) - 1), a_template)
		end

	make_with_name (name, a_template: READABLE_STRING_GENERAL)
		do
			create template.make (a_template)
			template_name := name_template #$ [generator, name]
			make_default
		end

feature -- Status query

	has_variable (name: STRING): BOOLEAN
		do
			Result:= template.has_variable (name)
		end

feature -- Element change

	put_object (object: EL_REFLECTIVE)
		local
			table: EL_REFLECTED_FIELD_TABLE; field: EL_REFLECTED_FIELD
		do
			table := object.field_table
			from table.start until table.after loop
				field := table.item_for_iteration
				if template.has_variable (field.name) then
					if attached {EL_REFLECTED_PATH} field as path_field then
						template.set_variable (field.name, path_field.value (object).escaped)
					elseif attached {EL_REFLECTED_URI} field as uri_field then
						template.set_variable (field.name, File_system.escaped_path (uri_field.value (object)))
					else
						template.set_variable (field.name, field.to_string (object))
					end
				end
				table.forth
			end
		end

	put_path (variable_name: STRING; a_path: EL_PATH)
		do
			template.set_variable (variable_name, a_path.escaped)
		end

	put_uri (variable_name: STRING; uri: EL_URI)
		require
			has_variable: has_variable (variable_name)
		do
			template.set_variable (variable_name, File_system.escaped_path (uri))
		end

	put_variable (object: ANY; variable_name: STRING)
		do
			if attached {EL_PATH} object as path then
				put_path (variable_name, path)
			else
				template.set_variable (variable_name, object)
			end
		end

feature {NONE} -- Implementation

	new_temporary_name: ZSTRING
		do
			Result := template_name.base
		end

	system_command: ZSTRING
		do
			Result := template.substituted
		end

	temporary_error_file_path: EL_FILE_PATH
		do
			Result := new_temporary_file_path ("err")
		end

feature {NONE} -- Internal attributes

	template: EL_ZSTRING_TEMPLATE

	template_name: EL_FILE_PATH

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "{%S.%S}.template"
		end

end