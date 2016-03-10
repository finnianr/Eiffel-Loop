note
	description: "Summary description for {EL_GENERAL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-20 9:43:34 GMT (Sunday 20th October 2013)"
	revision: "4"

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
			make_command
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

	temporary_file_name: ASTRING
		do
			Result := template_name.base
		end

	template_name: EL_FILE_PATH

	template: READABLE_STRING_GENERAL

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Constants

	Name_template: ASTRING
		once
			Result := "{$S}.$S"
		end

end
