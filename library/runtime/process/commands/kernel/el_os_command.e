note
	description: "General purpose OS command using an externally supplied template"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-03 13:21:32 GMT (Saturday 3rd February 2018)"
	revision: "3"

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

	put_path (variable_name: ZSTRING; a_path: EL_PATH)
		do
			getter_functions [variable_name] := agent escaped_path (a_path)
		end

	put_file_path (variable_name: ZSTRING; a_file_path: EL_FILE_PATH)
		do
			put_path (variable_name, a_file_path)
		end

	put_directory_path (variable_name: ZSTRING; a_dir_path: EL_DIR_PATH)
		do
			put_path (variable_name, a_dir_path)
		end

feature {NONE} -- Implementation

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.escaped
		end

	template: READABLE_STRING_GENERAL

	template_name: EL_FILE_PATH

	new_temporary_name: ZSTRING
		do
			Result := template_name.base
		end

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
