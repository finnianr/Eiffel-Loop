note
	description: "Summary description for {EL_GENERAL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 15:44:58 GMT (Sunday 19th June 2016)"
	revision: "6"

class
	EL_GENERAL_OS_COMMAND

inherit
	EL_OS_COMMAND [EL_GENERAL_COMMAND_IMPL]
		redefine
			temporary_file_name, template, template_name, redirect_errors
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
feature -- Status query

	redirect_errors: BOOLEAN

feature -- Status change

	enable_error_redirection
			-- enable appending of error messages to captured output
		do
			redirect_errors := True
		end

feature {NONE} -- Implementation

	template: READABLE_STRING_GENERAL

	template_name: EL_FILE_PATH

	temporary_file_name: ZSTRING
		do
			Result := template_name.base
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