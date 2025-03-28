note
	description: "Application desktop environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-29 12:05:49 GMT (Saturday 29th March 2025)"
	revision: "28"

deferred class
	EL_DESKTOP_ENVIRONMENT_I

inherit
	EVC_SERIALIZEABLE_AS_ZSTRING
		rename
			serialize_to_file as write_script,
			as_text as command_args,
			template as command_args_template,
			stripped_template as new_command_args_template
		export
			{NONE} all
		redefine
			make_default, new_command_args_template
		end

	EL_OS_DEPENDENT

	EL_MODULE_ARGS; EL_MODULE_BUILD_INFO; EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTABLE

	EL_STRING_8_CONSTANTS; EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_APPLICATION)
		do
			make_default
			description := installable.unwrapped_description
			command_option_name := installable.option_name
			menu_name := installable.name
			if attached {EL_MAIN_INSTALLABLE_APPLICATION} installable as main then
				set_app_compatibility (Build_info.app_compatibility_flags)
			end
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
			Result := Executable.name
		end

	command_line_options: ZSTRING

	command_option_name: READABLE_STRING_GENERAL

	command_path: FILE_PATH
		do
			Result := Directory.Application_bin + application_command
		-- Check if launcher script exists
			if attached new_script_path (Result) as script_path and then script_path.exists then
				Result := script_path
			end
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
				if not option.item.starts_with_character ('%%') then
					option.item.prepend_character ('-')
				end
			end
			command_line_options.share (option_list.as_word_string)
		end

	set_app_compatibility (flags: STRING)
		-- set Windows registry compatibility mode flags Eg. ~WIN7RTM
		deferred
		end

feature {NONE} -- Implementation

	new_script_path (a_command_path: FILE_PATH): FILE_PATH
		-- my_app.exe -> my_app.bat (Windows)
		-- my_app -> my_app.sh (Unix)
		deferred
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
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
			create lines.make_adjusted_split (command_args_template, '%N', {EL_SIDE}.Left)
			Result := lines.as_word_string
			Result.prune ('%T')
		end

end