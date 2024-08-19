note
	description: "Sub-application for a root class conforming to ${EL_MULTI_APPLICATION_ROOT}"
	notes: "[
		To create a localized sub-application redefine `new_locale' as follows:

			new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
				do
					create Result.make
				end

	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-19 10:50:47 GMT (Monday 19th August 2024)"
	revision: "92"

deferred class
	EL_APPLICATION

inherit
	EL_APPLICATION_IMPLEMENTATION

	EL_FALLIBLE
		export
			{NONE} all
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

feature {EL_FACTORY_CLIENT} -- Initialization

	initialize
			--
		deferred
		end

	make
		local
			app_mutex: detachable EL_APPLICATION_MUTEX
		do
			make_default
			if is_singleton then
				create app_mutex.make_for_application_mode (option_name)
				if attached app_mutex as mutex then
					mutex.try_lock
					is_another_launched := not mutex.is_locked -- Another instance of this app is running
				end
			end
			create_app_directories
			init_console
			if not (App_option.no_app_header or Base_option.silent) then
				io_put_header
			end
			if help_requested then
				print_help

			elseif not is_valid_platform then
				print_platform_help (0)

			else
				do_application
			end
			if attached app_mutex as mutex and then not is_another_launched then
				mutex.unlock
			end
		end

	make_default
		do
			make_solitary

			if is_switched then
				Directory.set_sub_app_dir (option_name)
			end

			-- Necessary to redefine `Build_info' as type `BUILD_INFO' if the project root class is `Current'
			call (Build_info)

			Exception.catch ({EXCEP_CONST}.Signal_exception)
			standard_options.do_all (agent do_with_options)
		end

feature -- Access

	default_option_name: STRING
		-- lower case generator with "_app" removed from tail
		-- and "el_" removed from head
		do
			Result := generator
			Result.to_lower
			if Result.ends_with ("_app") then
				Result.remove_tail (4)
			end
			if Result.starts_with ("el_") then
				Result.remove_head (3)
			end
		end

	description: READABLE_STRING_GENERAL
		deferred
		end

	exit_code: INTEGER

	option_name: READABLE_STRING_GENERAL
		-- command line switch option name
		do
			Result := default_option_name
		end

	options_help: EL_APPLICATION_HELP_LIST
		do
			create Result.make (11)
			across standard_options as options loop
				across options.item.help_table as help loop
					Result.extend (help.key, help.item.description, help.item.default_value)
				end
			end
		end

	unwrapped_description: ZSTRING
		-- description unwrapped as a single line
		do
			create Result.make_from_general (description)
			Result.to_canonically_spaced
		end

	user_config_dir: DIR_PATH
		do
			Result := Directory.app_configuration #+ new_option_name
		end

feature -- Basic operations

	run
		deferred
		end

	print_help
		do
			options_help.print_to_lio
			if not is_valid_platform then
				lio.put_line ("WARNING")
				lio.put_spaces (4)
				print_platform_help (4)
			end
		end

	print_platform_help (indent_count: INTEGER)
		do
			lio.put_labeled_substitution (
				hyphen.to_string + option_name, "this option is not designed for use on %S", [ OS_release.description]
			)
			lio.put_new_line
		end

feature -- Status query

	ask_user_to_quit: BOOLEAN
			--
		do
			Result := App_option.ask_user_to_quit
		end

	help_requested: BOOLEAN
		-- `True' if user requested help or other information
		do
			Result := App_option.help
		end

	is_another_launched: BOOLEAN
		-- `True' if another instance of this application is currently in operation
		-- in current user session

	is_same_option (name: ZSTRING): BOOLEAN
		do
			Result := name.same_string_general (option_name)
		end

	is_singleton: BOOLEAN
		-- when `True' only one instance of this application is allowed
		-- to be in operation in the current user session
		do
			Result := False
		end

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Element change

	set_exit_code (a_exit_code: INTEGER)
		do
			exit_code := a_exit_code
		end

	set_switched
		do
			is_switched := True
		end

feature {NONE} -- Implementation

	do_application
		local
			ctrl_c_pressed: BOOLEAN; l_timer: EL_EXECUTION_TIMER
		do
			if ctrl_c_pressed then
				on_operating_system_signal
			else
				if App_option.show_benchmarks then
					create l_timer.make; l_timer.start
					internal_timer := l_timer
				end
				read_command_options
				if has_error then
					print_errors (lio)
					if App_option.pause_on_error then
						return_to_quit
					end
				else
					call (new_configuration)
					initialize; run

					if attached internal_timer as timer then
						show_benchmarks (timer)
					end
					if ask_user_to_quit then
						return_to_quit
					end
				end
			end
		rescue
			-- NOTE: Windows does not trigger an exception on Ctrl-C
			if Exception.is_termination_signal then
				ctrl_c_pressed := True
				retry

			elseif attached Exception.last_exception.cause as cause then
				lio.put_labeled_substitution (
					cause.generator, "{%S}.%S Line %S", [cause.type_name, cause.recipient_name, cause.line_number]
				)
				lio.put_new_line
			end
		end

	do_with_options (options: EL_COMMAND_LINE_OPTIONS)
		-- do something with each of `standard_options'
		do
			if options = Environment_variable and then Environment_variable.define.count > 0 then
				set_environment_variable (Environment_variable.define)
			end
		end

	init_console
		local
			list: like visible_types_list
		do
			list := visible_types_list
			if not list.all_conform then
				list.log_error (lio, "Error in function `visible_types'")
			end
			Console.show_all (list.to_array)
		end

	io_put_header
		local
			build_version, test: STRING
		do
			lio.put_new_line
			test := "test"
			if App_option.test then
				build_version := test
			else
				build_version := Software_version.out
			end
			lio.put_field_list (100, << ["Executable", Executable.name], ["Version", build_version] >>)
			lio.put_new_line
			lio.put_field_list (100, << ["Class", generator], ["Option", option_name] >>)
			lio.put_new_line
			if description.has ('%N') then
				lio.put_labeled_lines ("Description", description.split ('%N'))
			else
				lio.put_string_field ("Description", description)
			end
			lio.put_new_line_X2
		end

	set_environment_variable (assignment: ZSTRING)
		-- defines an environment variable if `Environment_variable' is added to
		-- redefinition of `standard_options' and command line has option: -define
		local
			error: EL_COMMAND_ARGUMENT_ERROR; environ_variable: EL_ENVIRON_VARIABLE
			template: ZSTRING
		do
			environ_variable := assignment
			if environ_variable.is_valid then
				environ_variable.apply
			else
				create error.make ("define")
				error.argument.share (assignment)
				if environ_variable.is_empty then
					error.set_invalid_argument ("Use format: -define name=<value>")

				elseif not environ_variable.is_valid_name then
					template := "'%S' is not a valid environment label"
					error.set_invalid_argument (template #$ [environ_variable.name])
				end
				put (error)
			end
		end

	standard_options: EL_ARRAYED_LIST [EL_COMMAND_LINE_OPTIONS]
		-- Standard command line options
		do
			create Result.make_from_array (<< Base_option, new_command_options >>)
		end

note
	descendants: "[
		**eiffel.ecf**
			EL_APPLICATION*
				${PROJECT_MANAGER_APP}
				${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
				${EL_VERSION_APP}
				${EL_STANDARD_UNINSTALL_APP}
				${EL_LOGGED_APPLICATION*}
					${EL_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
						${EL_CRC_32_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
							${AUTOTEST_APP}

		See also: ${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}

		**toolkit.ecf**
			EL_APPLICATION*
				${BINARY_DECODE_APP}
				${DIAGNOSTICS_APP}
				${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
				${EL_VERSION_APP}
				${EL_LOGGED_APPLICATION*}
					${EL_LOGGED_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
					${EL_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
						${EL_CRC_32_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
							${AUTOTEST_APP}
				${EL_STANDARD_UNINSTALL_APP}
				
		**test.ecf**
			EL_APPLICATION*
				${EL_STANDARD_REMOVE_DATA_APP}
				${EL_BATCH_AUTOTEST_APP}
					${AUTOTEST_APP}
				${EL_VERSION_APP}
				${EL_STANDARD_UNINSTALL_APP}
				${EL_LOGGED_APPLICATION*}
				${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
					${EL_LOGGED_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}

			See also: ${EL_LOGGED_APPLICATION} and ${EL_AUTOTEST_APPLICATION}
					
		**manage-mp3.ecf**
			EL_APPLICATION*
				${EL_VERSION_APP}
				${EL_STANDARD_UNINSTALL_APP}
				${EL_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
					${TANGO_MP3_FILE_COLLATOR_APP}
					${EL_DEBIAN_PACKAGER_APP}
					${GENERATE_RBOX_DATABASE_FIELD_ENUM_APP}
					${ID3_EDITOR_APP}
					${EL_LOGGED_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
						${MP3_AUDIO_SIGNATURE_READER_APP}
						${RHYTHMBOX_MUSIC_MANAGER_APP}
				${EL_LOGGED_APPLICATION*}
					${EL_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
						${EL_CRC_32_AUTOTEST_APPLICATION* [EQA_TYPES -> TUPLE create default_create end]}
							${AUTOTEST_APP}
					${EL_LOGGED_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}

	]"
end