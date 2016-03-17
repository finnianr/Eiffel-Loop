note
	description: "Summary description for {EL_APPLICATION_INSTALLER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:52:38 GMT (Thursday 24th December 2015)"
	revision: "6"

deferred class
	EL_APPLICATION_INSTALLER

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			serialize_to_file as write_script,
			as_text as command_args,
			template as Command_args_template
		redefine
			make_default
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_ARGS

feature {NONE} -- Initialization

	make_default
		do
			create command_option_name.make_empty
			create command_line_options.make_empty
			create description.make_empty
			create menu_name.make_empty
			create input_path_option_name.make_empty
			Precursor
		end

feature -- Basic operations

	install
			--
		deferred
		end

	uninstall
			--
		deferred
		end

feature -- Access

	command_option_name: STRING

	command_line_options: ZSTRING

	description: ZSTRING

	menu_name: ZSTRING

	input_path_option_name: STRING

	command: ZSTRING
			--
		do
			Result := Environment.Execution_environment.Executable_name
		end

feature -- Element change

	set_command_option_name (a_command_option_name: like command_option_name)
			--
		do
			command_option_name := a_command_option_name
		end

	set_command_line_options (a_command_line_options: like command_line_options)
			--
		do
			command_line_options := a_command_line_options
		end

	set_description (a_description: like description)
			--
		do
			description := a_description
		end

	set_input_path_option_name (a_input_path_option_name: STRING)
			--
		do
			input_path_option_name := a_input_path_option_name
		end

feature {NONE} -- Evolicity implementation

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["title", agent: ZSTRING do Result := menu_name.as_upper end],
				["command", agent command],
				["sub_application_option", agent: STRING do Result := command_option_name end],
				["command_options", agent: ZSTRING do Result := command_line_options end]
			>>)
		end

end
