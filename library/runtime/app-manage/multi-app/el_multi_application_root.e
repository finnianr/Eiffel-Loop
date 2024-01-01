note
	description: "[
		Selects a sub-application to launch from a shared list of uninitialized instances conforming to [$source EL_APPLICATION].
		The list is created using types defined by the `APPLICATION_TYPES' tuple parameter. A command line option matching the string
		value `{EL_APPLICATION}.option_name' selects that instance. Calling `make' on the selected instance executes the sub-application.
	]"
	notes: "[
		The [$source EL_VERSION_APP] application is automatically added to list of instances defined by `APPLICATION_TYPES' tuple.

		Can also install/uninstall any sub-application conforming to [$source EL_INSTALLABLE_APPLICATION].
		(System file context menu or system application launch menu) See sub-applications:

			[$source EL_STANDARD_INSTALLER_APP]
			[$source EL_STANDARD_UNINSTALL_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 14:25:51 GMT (Monday 1st January 2024)"
	revision: "29"

deferred class
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO create make end, APPLICATION_TYPES -> TUPLE create default_create end]

inherit
	ANY

	EL_FACTORY_CLIENT

	EL_MODULE_ASCII; EL_MODULE_ARGS; EL_MODULE_ENVIRONMENT; EL_MODULE_EXECUTABLE

	EL_MODULE_LIO
		rename
			Lio as Later_lio,
			new_lio as new_temporary_lio
		end

feature {NONE} -- Initialization

	make
			--
		local
			list: EL_APPLICATION_LIST; lio: EL_LOGGABLE; exit_code: INTEGER
		do
			create_singletons
			if {PLATFORM}.is_windows and then not Base_option.silent then
				-- Force console creation. Needed to set `{EL_EXECUTION_ENVIRONMENT_I}.last_codepage'

				io.put_character (ASCII.back_space.to_character_8)

--				Environment.Execution.set_utf_8_console_output
					-- Only has effect in Windows command console
			end
			-- Must be called before current_working_directory changes
			if Executable.path.is_file then
			end
			lio := new_temporary_lio -- until the logging is initialized in `EL_APPLICATION'

--			Environment.Execution.restore_last_code_page
--			FOR WINDOWS
--			If the original code page is not restored after changing to 65001 (utf-8)
--			this could effect subsequent programs that run in the same shell.
--			Python for example might give a "LookupError: unknown encoding: cp65001" error.

			create list.make (new_type_list (new_application_types))

			if attached new_platform_types as extra_types and then extra_types.count > 0 then
			-- platform specific
				list.append_types (new_type_list (extra_types))
			end
			list.extend (create {EL_VERSION_APP})

			list.find (lio, Args.option_name (1))
			if list.found and then attached list.item as app then
				app.make -- Initialize and run sub-application

				exit_code := app.exit_code

				lio.put_new_line
				lio.put_new_line
			end

			list.make_empty

				-- Can cause a crash on multi-threaded applications if implementation of `dispose' has errors
			{MEMORY}.full_collect

			if exit_code > 0 then
				Execution_environment.exit (exit_code)
			end
		end

feature {NONE} -- Implementation

	create_singletons
		-- create shared objects conforming to `EL_SOLITARY'
		local
			shared_build_info: B
		do
			create shared_build_info.make
		end

	new_application_types: APPLICATION_TYPES
		-- TUPLE containing all sub-application types
		do
			create Result
		ensure
			all_conform_to_EL_APPLICATION: new_type_list (Result).all_conform
		end

	new_platform_types: TUPLE
		-- extra platform specific types to supplement `new_application_types'
		do
			create Result
		ensure
			all_conform_to_EL_APPLICATION: new_type_list (Result).all_conform
		end

	new_type_list (type_tuple: TUPLE): EL_TUPLE_TYPE_LIST [EL_APPLICATION]
		-- list of types in `type_tuple' conforming to `EL_APPLICATION'
		do
			create Result.make_from_tuple (type_tuple)
		end

end