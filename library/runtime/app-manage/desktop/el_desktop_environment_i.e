note
	description: "Application desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-20 12:29:40 GMT (Wednesday 20th June 2018)"
	revision: "7"

deferred class
	EL_DESKTOP_ENVIRONMENT_I

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			serialize_to_file as write_script,
			as_text as command_args,
			template as command_args_template,
			stripped_template as new_command_args_template
		redefine
			make_default, new_command_args_template
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_COMMAND

	EL_MODULE_ARGS

	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_SUB_APPLICATION)
		do
			make_default
			description := installable.unwrapped_description
			command_option_name := installable.option_name
			menu_name := installable.name
		end

	make_default
		do
			command_option_name := Empty_string_8
			create command_line_options.make_empty -- since we are appending items
			description := Empty_string
			menu_name := Empty_string
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

	application_command: ZSTRING
		do
			Result := Environment.Execution.Executable_name
		end

	command_line_options: ZSTRING

	command_option_name: READABLE_STRING_GENERAL

	command_path: EL_FILE_PATH
		do
			Result := Directory.Application_bin + application_command
		end

	description: ZSTRING

	launch_command: ZSTRING
			--
		do
			Result := File_system.escaped_path (command_path)
		end

	menu_name: ZSTRING

feature -- Element change

	set_command_line_options (option_list: ITERABLE [READABLE_STRING_GENERAL])
			-- set list of command options prepending a hyphen to each
		do
			command_line_options.wipe_out
			across option_list as option loop
				if not command_line_options.is_empty then
					command_line_options.append_character (' ')
				end
				command_line_options.append_character ('-')
				command_line_options.append_string_general (option.item)
			end
		end

feature {NONE} -- Evolicity implementation

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["command_args",				agent command_args], -- recursion (as_text as command_args)
				["command_path",				agent: ZSTRING do Result := command_path.escaped end],
				["menu_name",					agent: ZSTRING do Result := menu_name end],
				["launch_command",			agent launch_command],
				["application_command",		agent application_command],
				["sub_application_option", agent: READABLE_STRING_GENERAL do Result := command_option_name end],
				["command_options",			agent: ZSTRING do Result := command_line_options end]
			>>)
		end

	new_command_args_template: ZSTRING
			-- Evolicity template
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_separator (command_args_template.to_string_8, '%N', True)
			Result := lines.joined_words
			Result.prune ('%T')
		end

end
