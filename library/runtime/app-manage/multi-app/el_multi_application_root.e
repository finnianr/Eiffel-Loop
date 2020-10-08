note
	description: "[
		Selects an application to launch from an array of sub-applications by either user input or command switch.
		
		Can also install/uninstall any sub-application conforming to [$source EL_INSTALLABLE_SUB_APPLICATION].
		(System file context menu or system application launch menu) See sub-applications:
			[$source EL_STANDARD_INSTALLER_APP]
			[$source EL_STANDARD_UNINSTALL_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-08 9:19:26 GMT (Thursday 8th October 2020)"
	revision: "19"

deferred class
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO create default_create end, APPLICATION_TYPES -> TUPLE create default_create end]

inherit
	EL_FACTORY_CLIENT

	EL_MODULE_ARGS

	EL_MODULE_ENVIRONMENT

	EL_MODULE_EXECUTABLE

	EL_MODULE_LIO
		rename
			Lio as Later_lio,
			new_lio as new_temporary_lio
		end

feature {NONE} -- Initialization

	make
			--
		local
			list: EL_SUB_APPLICATION_LIST; lio: EL_LOGGABLE; exit_code: INTEGER
		do
			create_singletons
			if not Base_option.silent then
				-- Force console creation. Needed to set `{EL_EXECUTION_ENVIRONMENT_I}.last_codepage'

				io.put_character ({ASCII}.back_space.to_character_8)

--				Environment.Execution.set_utf_8_console_output
					-- Only has effect in Windows command console
			end
			-- Must be called before current_working_directory changes
			if Executable.path.is_file then
			end
			lio := new_temporary_lio -- until the logging is initialized in `EL_SUB_APPLICATION'

--			Environment.Execution.restore_last_code_page
--			FOR WINDOWS
--			If the original code page is not restored after changing to 65001 (utf-8)
--			this could effect subsequent programs that run in the same shell.
--			Python for example might give a "LookupError: unknown encoding: cp65001" error.

			create list.make (create {APPLICATION_TYPES})
			list.extend (create {EL_VERSION_APP})
			list.find (lio, Args.option_name (1))
			if list.found and then attached list.item as app then
				app.make -- Initialize and run application

				exit_code := app.exit_code

				lio.put_new_line
				lio.put_new_line
			end

			list.make_empty

				-- Causes a crash on some multi-threaded applications
			{MEMORY}.full_collect

			if exit_code > 0 then
				Execution_environment.exit (exit_code)
			end
		end

feature {NONE} -- Implementation

	create_singletons
		-- create shared objects conforming to `EL_SOLITORY'
		local
			shared_build_info: B
		do
			create shared_build_info
		end
end