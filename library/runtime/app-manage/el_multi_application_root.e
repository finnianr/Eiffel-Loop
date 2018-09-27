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
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "7"

deferred class
	-- Generic to make sure scons generated `BUILD_INFO' is compiled from project source
	EL_MULTI_APPLICATION_ROOT [B -> EL_BUILD_INFO]

inherit
	EL_MODULE_ARGS

	EL_MODULE_ENVIRONMENT

	EL_SHARED_APPLICATION_LIST
		redefine
			new_application_list
		end

feature {NONE} -- Initialization

	make
			--
		do
			if not Args.has_silent then
				-- Force console creation. Needed to set `{EL_EXECUTION_ENVIRONMENT_I}.last_codepage'

				io.put_character ({ASCII}.back_space.to_character_8)

--				Environment.Execution.set_utf_8_console_output
					-- Only has effect in Windows command console
			end
			-- Must be called before current_working_directory changes
			if Environment.Execution.Executable_path.is_file then
			end
			Application_list.launch (Args.option_name (1))
--				Environment.Execution.restore_last_code_page
--				FOR WINDOWS
--				If the original code page is not restored after changing to 65001 (utf-8)
--				this could effect subsequent programs that run in the same shell.
--				Python for example might give a "LookupError: unknown encoding: cp65001" error.

			Application_list.make_empty
				-- Causes a crash on some multi-threaded applications
			{MEMORY}.full_collect
		end

feature {NONE} -- Implementation

	application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		deferred
		end

	new_application_list: EL_SUB_APPLICATION_LIST
		do
			create Result.make (application_types, select_first)
			Result.extend (create {EL_VERSION_APP})
		end

	select_first: BOOLEAN
		-- if `True' first application in `Application_list' selected by default
		do
		end

end
