note
	description: "Application desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-03 8:56:35 GMT (Wednesday 3rd July 2019)"
	revision: "9"

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

	EL_STRING_8_CONSTANTS

	EL_ZSTRING_CONSTANTS

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

	set_command_line_options (options: ITERABLE [READABLE_STRING_GENERAL])
			-- set `command_line_options' from `options' prepending a hyphen to each except if the option is a place holder
		local
			option_list: EL_ZSTRING_LIST
		do
			create option_list.make_from_general (options)
			across option_list as option loop
				if not (option.item.count > 0 and then option.item [1] = '%%') then
					option.item.prepend_character ('-')
				end
			end
			command_line_options.share (option_list.joined_words)
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
